import os, random, terminal
randomize()

var screenWidth: int = terminalWidth()
var screenHeight: int = terminalHeight()

# stdout.eraseScreen()
stdout.hideCursor()

proc newdrop(): tuple[x, y, chr, style, color, counter, delay: int] =
  let
    x = rand(screenWidth)
    delay = rand(16)
    color = rand(2)
  var style = 0
  var chr = int('.')
  if delay < 4:
    chr = int(':')
    style = 1
  if delay < 2:
    chr = int('|')
  result = (x, 0, chr, style, color, 0, delay)

# Setup drops array
var drops: array[0..150, tuple[x, y, chr, style, color, counter, delay: int]]
for i in 0..drops.high:
  drops[i] = newdrop()

while true:
  screenWidth = terminalWidth()
  screenHeight = terminalHeight()
  for i in 0..drops.high:
    var (x, y, chr, style, color, counter, delay) = drops[i]
    stdout.setCursorPos(x, y)
    stdout.styledWriteLine(fgBlack, " ")

    counter += 1
    if counter >= delay:
      counter = 0
      if y < screenHeight - 2:
        y += 1
      else:
        drops[i] = newdrop()
        (x, y, chr, style, color, counter, delay) = drops[i]
    drops[i] = (x, y, chr, style, color, counter, delay)

    stdout.setCursorPos(x, y)
    var c:enum = fgGreen
    if color == 1:
      c = fgWhite
    elif color == 2:
      c = fgBlack
    var s:enum = styleDim
    if style == 1:
      s = styleBright
    stdout.styledWriteLine(s, c, $char(chr))

  sleep(1)
