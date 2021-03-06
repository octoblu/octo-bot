_             = require 'lodash'
Server        = require './src/server'

class Command
  constructor: ->
    @serverOptions =
      port:           process.env.PORT
      disableLogging: process.env.DISABLE_LOGGING == "true"

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    # Use this to require env
    # @panic new Error('Missing required environment variable: ENV_NAME') if _.isEmpty @serverOptions.envName

    server = new Server @serverOptions
    server.run (error, result) =>
      console.log "Result", result
      return @panic error if error?

      {address,port} = server.address()
      console.log "Server listening on #{address}:#{port}"

command = new Command()
command.run()
