# publishresults

Takes the output of a command, and serves it on a page.

## Installation

    npm install -g publishresults

## Example

Run the following command:

    publishresults 'while true; do date; sleep 1; done'

It will show you the output on the command line, and will also give you a URL. Visit http://localhost:9876 (9876 is the default port), and you will also see the output there. The browser-side code will automatically refresh every second, if new content is available.

## License

MIT

## Credits

Author: [Geza Kovacs](http://github.com/gkovacs)

