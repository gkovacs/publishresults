root = exports ? this

root.maxidx = 0
root.firstload = true

export refreshMessages = ->
  $.getJSON '/messages?idx=' + root.maxidx, (messages) ->
    shouldscroll = atBottom() or root.firstload
    root.firstload = false
    for {type, text, time, idx} in messages
      root.maxidx = Math.max(root.maxidx, idx + 1)
      lines = text.split('\n')
      if lines[*-1] == ''
        lines = lines[til -1]
      for line in lines
        switch type
        | 'stdout' =>
          $('#messages').append $('<div>').append [$('<div>').css({'background-color': '#BFD2FF', 'margin-right': '5px', 'display': 'inline-block'}).text(new Date(time).toString()), $('<div>').css({'display': 'inline-block'}).text(line)]
        | 'stderr' =>
          $('#messages').append $('<div>').append [$('<div>').css({'background-color': '#BFD2FF', 'margin-right': '5px', 'display': 'inline-block'}).text(new Date(time).toString()), $('<span>').css({'display': 'inline-block', 'background-color': 'yellow'}).text(line)]
    if shouldscroll
      window.scrollTo 0, $(document).height() - window.innerHeight
    return

export atBottom = ->
  return window.scrollY >= ($(document).height() - window.innerHeight) - 100

$(document).ready ->
  setInterval refreshMessages, 1000
  