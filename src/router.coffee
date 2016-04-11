msRest            = require 'ms-rest'
connector         = require 'botconnector'
OctoBotController = require './controllers/octo-bot-controller'
verifyCredentials = require './middleware/verify-credentials'

class Router
  constructor: ({@octoBotService, @botConfig}) ->

  route: (app) =>
    octoBotController = new OctoBotController {@octoBotService, @botConfig}
    app.post '/api/messages', verifyCredentials, octoBotController.receiveMessages

module.exports = Router
