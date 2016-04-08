msRest            = require 'ms-rest'
connector         = require 'botconnector'
OctoBotController = require './controllers/octo-bot-controller'
verifyCredentials = require './middleware/verify-credentials'

class Router
  constructor: ({@octoBotService, @botConfig}) ->

  route: (app) =>
    octoBotController = new OctoBotController {@octoBotService, @botConfig}
    app.get '/hello', octoBotController.hello
    app.post '/v1/api/messages', verifyCredentials, octoBotController.receiveMessages

module.exports = Router
