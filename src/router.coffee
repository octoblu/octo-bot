msRest            = require 'ms-rest'
connector         = require 'botconnector'
botbuilder           = require 'botbuilder'
dialog            = './bot/dialog/index'
verifyCredentials = require './middleware/verify-credentials'

class Router
  constructor: ({@botConfig}) ->
    {appId, appSecret} = @botConfig
    @bot = new botbuilder.BotConnectorBot {appId, appSecret}
    @bot.add '/', dialog

  route: (app) =>
    app.post '/api/messages', verifyCredentials, @bot.listen()

module.exports = Router
