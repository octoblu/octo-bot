connector = require 'botconnector'
msRest = require 'ms-rest'

class OctoBotController
  constructor: ({@octoBotService, @botConfig}) ->
    {appId, appSecret} = @botConfig
    @credentials = new msRest.BasicAuthenticationCredentials appId, appSecret

  sendMessage: (msg, cb) =>
    client = new connector @credentials
    options =
      customHeaders:
        'Ocp-Apim-Subscription-Key': @botConfig.appSecret

    console.log 'Send MEssage', msg
    client.messages.sendMessage msg, options, (err, result, request, response) =>
      err = new Error "Message rejected with #{response.statusMessage}" if (!err &&response?.statusCode >= 400)
      cb err if (cb)

  receiveMessages: (req, res) =>
    console.log 'req.body', req.body
    {id, from, to, text} = req.body

    reply =
      replyToMessageId: id
      to: from
      from: to
      text: "I heard #{text}"
    #
    @sendMessage reply, () => res.st
    # res.status(200).send('got it!')

  hello: (request, response) =>
    {hasError} = request.query

    @octoBotService.doHello {hasError}, (error) =>
      return response.status(error.code || 500).send(error: error.message) if error?
      response.sendStatus(200)

module.exports = OctoBotController
