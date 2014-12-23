#!/usr/bin/env lsc

require! 'express'
require! 'jsdom'
$ = require('jquery')(jsdom.jsdom().parentWindow)
{spawn} = require 'child_process'

export publishresults = ->
  if not process.argv[2]? or process.argv[2].toString() == ''
    console.log 'need command to run'
    return
  cmd = spawn 'bash', [ '-c', process.argv[2] ]

  messages = []

  cmd.stdout.on 'data', (data) ->
    nd = data.toString()
    messages.push {type: 'stdout', text: nd}
    process.stdout.write nd

  cmd.stderr.on 'data', (data) ->
    nd = data.toString()
    messages.push {type: 'stderr', text: nd}
    process.stdout.write nd

  app = express()

  for portnum from 9000 to Infinity
    try
      app.listen portnum, '0.0.0.0'
      break
    catch
      continue

  console.log 'listening on port: ' + portnum

  messages_to_html = ->
    output = $('<div>')
    for {type, text} in messages
      for line in text.split('\n')
        switch type
        | 'stdout' =>
          output.append $('<div>').text(line)
        | 'stderr' =>
          output.append $('<div>').css('background-color', 'yellow').text(line)
    return '<html><head><meta charset="UTF-8"></head><body>' + output.html() + '</body></html>'

  app.get '/', (req, res) ->
    res.content-type 'text/html'
    res.send messages_to_html()
