use std::path::PathBuf;

use clap::Parser;
use clap_verbosity_flag::Verbosity;

#[derive(Debug, Parser)]
pub struct Args {
    /// The file to read from
    pub input: String,
    /// The file to write to. If not specified, stdout is used. To use with nomad, use - as the filename for the nomad command. 
    pub output: Option<PathBuf>,
    /// The directory to search for replacement templates. Defaults to ./templates/**/*.tera
    #[clap(short, long, default_value = "./templates/**/*.tera")]
    pub replacement_templates: PathBuf,
    /// The verbosity level. Use `-v` or `--verbose` for INFO level logging, `-vv` or `--verbose --verbose` for DEBUG level logging, and `-vvv` or `--verbose --verbose --verbose` for TRACE level logging.
    #[command(flatten)]
    pub verbose: Verbosity,
}
