connector = require 'botconnector'
MSRest = require 'ms-rest'
request = require 'request'

class OctoBotController
  constructor: ({@octoBotService, @botConfig}) ->
    @triggerUrl = "https://triggers.octoblu.com/flows/8638d8ea-5fd0-4073-be96-ce37977d8372/triggers/4a6d8ac0-ff8e-11e5-bd3d-6fccd197489c"
    {appId, appSecret} = @botConfig
    @credentials = new MSRest.BasicAuthenticationCredentials appId, appSecret

  sendMessage: (msg, cb) =>
    client = new connector @credentials
    options =
      customHeaders:
        'Ocp-Apim-Subscription-Key': @botConfig.appSecret

    console.log 'Send Message', msg
    client.messages.sendMessage msg, options, (err, result, request, response) =>
      err = new Error "Message rejected with #{response.statusMessage}" if (!err &&response?.statusCode >= 400)
      cb err if (cb)

  receiveMessages: (req, res) =>
    console.log 'req.body', req.body
    msg = req.body

    request.post @triggerUrl,
      json: true
      body: msg
      
    reply =
      replyToMessageId: msg.id
      to: msg.from
      from: msg.to
      text: "I heard #{msg.text}"
    #
    @sendMessage reply, () => res.status(200).send('OK')
    # res.status(200).send('got it!')

  hello: (request, response) =>
    {hasError} = request.query

    @octoBotService.doHello {hasError}, (error) =>
      return response.status(error.code || 500).send(error: error.message) if error?
      response.sendStatus(200)

module.exports = OctoBotController
