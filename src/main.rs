use std::{fs::{self}, io::{self, Write, BufWriter}};

use clap::Parser;
use log::{error, info, debug};
use tera::{Tera, Context};
use itertools::Itertools; // 0.8.2

use crate::cli::Args;

mod cli;

fn main() {
    let Args {
        input,
        output,
        replacement_templates,
        verbose
    } = Args::parse();

    env_logger::Builder::new()
        .filter_level(verbose.log_level_filter())
        .init();
    
    let output: Box<dyn Write> = if let Some(output) = output {
        info!("Will write to file `{output:?}`");
        Box::new(BufWriter::new(fs::File::create(output).unwrap()))
    } else {
        info!("Will write to stdout");
        Box::new(BufWriter::new(io::stdout()))
    };


    debug!("Searching for replacement templates in `{}`", replacement_templates.to_string_lossy());

    let mut templates_terra = Tera::new(&replacement_templates.to_string_lossy()).unwrap();

    let thing = templates_terra.templates.keys().join(", ");
    info!("Found the following templates: {}", thing);

    match templates_terra.check_macro_files() {
        Ok(_) => {info!("All macros are valid");},
        Err(e) => {
            error!("Error(s) parsing templates: {}", e);
            std::process::exit(1);
        }
    };

    match templates_terra.add_template_file( &input, Some("input")) {
        Ok(_) => {
            info!("Added template file `{}`", &input);
        }
        Err(e) => {
            error!("Error(s) parsing templates: {}", e);
            std::process::exit(1);
        }
    };
    
    let context = Context::new();

    templates_terra.render_to("input", &context, output).unwrap();

    info!("Done");
}
