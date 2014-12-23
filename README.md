# publishresults

Takes the output of a command, and serves it on a page.

## Installation

    npm install -g publishresults

## Example

Run the following command:

    publishresults 'while true; do date; sleep 1; done'

It will show you the output on the command line, and will also give you a port. Visit http://localhost:9000 (or wherever it is running), and you will also see the output there.

## TODO

The client-side code does not update live at the moment (you have to refresh manually). Should be implementable using websockets. Pull requests appreciated.

## License

MIT

## Credits

Author: [Geza Kovacs](http://github.com/gkovacs)

