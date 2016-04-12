_           = require 'lodash'
builder     = require 'botbuilder'
MeshbluHttp = require 'meshblu-http'

prompts     = require '../prompts'
modelConfig = require '../../config/model-config'

modelUrl = "https://api.projectoxford.ai/luis/v1/application?id=#{modelConfig.modelAppId}&subscription-key=#{modelConfig.subscriptionKey}&q="

getName = (session, results, next) =>
  builder.Prompts.text session, prompts.getName

setName = (session, results, next) =>
  name = results.response if results.response.length?
  session.userData.name = name
  next()

showHelp = (session, results, next) =>
  session.send prompts.helpMessage
  session.replaceDialog '/'

module.exports = [getName, setName, showHelp]
