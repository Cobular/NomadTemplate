# Nomad Template

Adds Tera templating support for Nomad jobfiles

## Usage

Put files in the templates folder that define macros. These will always be loaded into scope.

Then, import the files you want from the `.nomadtemplate` with the header `{% import "traefik.tera" as traefik %}` somewhere in the file. Do not specify the path to the file with the macros, just it's name.

Finally, call the templates as follows: `{{ traefik::private(service_name="umami", subdomain="umami") }}`

## Default templates

Currently, there are 2 templates - both for traefik, one to make a service public and one to make it private. They have one required parameter - the service name - and on 2 optionals - the subdomain, which if unspecificed will be the service name, and the base domain, which by default is one thing but can be overridden on a per-service basis. 
