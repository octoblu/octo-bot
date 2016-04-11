builder = require 'botbuilder'
index = require './dialog/index'
textBot = new builder.TextBot()

# textBot.use (session, next) =>
#   if(!session.userData.firstRun)
#     session.userData.firstRun = true
#     session.beginDialog '/firstRun'
#   else
#     next()
# textBot.add '/firstRun', [
#   (session) => builder.Prompts.text session, "Hello...What's your name?",
#   (session, results) =>
#     session.userData.name = results.response
#     session.replaceDialog '/'
#   ]

textBot.add '/', index
textBot.listenStdin()
