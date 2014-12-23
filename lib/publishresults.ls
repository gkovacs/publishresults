#!/usr/bin/env lsc

require! 'express'
require! 'path'
{spawn} = require 'child_process'
CBuffer = require 'CBuffer'

export publishresults = ->
  if not process.argv[2]? or process.argv[2].toString() == ''
    console.log 'need command to run'
    return
  cmd = spawn 'bash', [ '-c', process.argv[2] ]

  messages = new CBuffer(1000)
  curidx = 0

  cmd.stdout.on 'data', (data) ->
    nd = data.toString()
    messages.push {type: 'stdout', text: nd, time: Date.now(), idx: curidx}
    curidx := curidx + 1
    process.stdout.write nd

  cmd.stderr.on 'data', (data) ->
    nd = data.toString()
    messages.push {type: 'stderr', text: nd, time: Date.now(), idx: curidx}
    curidx := curidx + 1
    process.stdout.write nd

  app = express()

  for portnum from 9876 to Infinity
    try
      app.listen portnum, '0.0.0.0'
      break
    catch
      continue

  console.log 'visit the following url in your browser: http://localhost:' + portnum

  app.get '/', (req, res) ->
    res.content-type 'text/html'
    res.send '''
    <!DOCTYPE html>
    <html>
    <head><meta charset="UTF-8"></head>
    <body>
    <script src="jquery-1.11.1.min.js"></script>
    <script src="webindex.js"></script>
    <div id="messages"></div>
    </body>
    </html>
    '''

  app.get '/messages', (req, res) ->
    output = []
    minidx = 0
    if req.query.idx?
      minidx = parseInt req.query.idx
    messages.forEach (msgelem) ->
      if msgelem.idx >= minidx
        output.push msgelem
    res.send JSON.stringify output

  app.get '/jquery-1.11.1.min.js', (req, res) ->
    res.sendFile path.join(__dirname, 'jquery-1.11.1.min.js')

  app.get '/webindex.js', (req, res) ->
    res.sendFile path.join(__dirname, 'webindex.js')
