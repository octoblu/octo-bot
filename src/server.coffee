cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
MeshbluConfig      = require 'meshblu-config'
debug              = require('debug')('octo-bot:server')

Router             = require './router'
botConfig          = require './config/bot-credentials'

class Server
  constructor: ({@disableLogging, @port}, {@meshbluConfig})->
    @meshbluConfig ?= new MeshbluConfig().toJSON()

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use meshbluHealthcheck()
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    app.options '*', cors()

    router = new Router({@botConfig: botConfig})

    router.route app

    return @server = app.listen(callback) unless @port
    return @server = app.listen(@port, callback)

  stop: (callback) =>
    @server.close callback

module.exports = Server
