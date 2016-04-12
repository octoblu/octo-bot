builder = require 'botbuilder'
index   = require './dialog/index'
beginDialog = require './dialog/begin.dialog'


textBot = new builder.TextBot()

# textBot.use (session, next) =>
#   console.log "firstRun #{session.userData.firstRun}"
#   next() unless session.userData.firstRun?
#   session.userData.firstRun = true
#   session.beginDialog '/BeginDialog'

textBot.add '/', index
textBot.add '/BeginDialog', beginDialog

textBot.listenStdin()
