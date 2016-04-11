builder = require 'builder'
index = require './dialog/index'
textBot = new builder.TextBot()
textBot.add '/', index
textBot.listenStdin()
