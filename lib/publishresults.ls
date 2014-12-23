#!/usr/bin/env lsc

require! 'express'
$ = require 'cheerio'
{spawn} = require 'child_process'
CBuffer = require 'CBuffer'

export publishresults = ->
  if not process.argv[2]? or process.argv[2].toString() == ''
    console.log 'need command to run'
    return
  cmd = spawn 'bash', [ '-c', process.argv[2] ]

  messages = new CBuffer(1000)

  cmd.stdout.on 'data', (data) ->
    nd = data.toString()
    messages.push {type: 'stdout', text: nd, time: Date.now()}
    process.stdout.write nd

  cmd.stderr.on 'data', (data) ->
    nd = data.toString()
    messages.push {type: 'stderr', text: nd, time: Date.now()}
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
    #for {type, text, time} in messages
    messages.forEach (msgelem) ->
      {type, text, time} = msgelem
      lines = text.split('\n')
      if lines[*-1] == ''
        lines = lines[til -1]
      for line in lines
        switch type
        | 'stdout' =>
          output.append $('<div>').append [$('<div>').css({'background-color': '#BFD2FF', 'margin-right': '5px', 'display': 'inline-block'}).text(new Date(time).toString()), $('<div>').css({'display': 'inline-block'}).text(line)]
        | 'stderr' =>
          output.append $('<div>').append [$('<div>').css({'background-color': '#BFD2FF', 'margin-right': '5px', 'display': 'inline-block'}).text(new Date(time).toString()), $('<span>').css({'display': 'inline-block', 'background-color': 'yellow'}).text(line)]
    return '<html><head><meta charset="UTF-8"></head><body>' + output.html() + '</body></html>'

  app.get '/', (req, res) ->
    res.content-type 'text/html'
    res.send messages_to_html()
