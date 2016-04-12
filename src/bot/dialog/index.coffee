_           = require 'lodash'
builder     = require 'botbuilder'
MeshbluHttp = require 'meshblu-http'

prompts     = require '../prompts'
modelConfig = require '../../config/model-config'

modelUrl = "https://api.projectoxford.ai/luis/v1/application?id=#{modelConfig.modelAppId}&subscription-key=#{modelConfig.subscriptionKey}&q="

dialog = new builder.LuisDialog(modelUrl)

showHelp = (session) =>
  builder.DialogAction.send prompts.helpMessage

getOctobluUUID = (session) =>
  builder.Prompts.text session, prompts.getMeshbluUUID

setOctobluUUID = (session, results, next) =>
  session.userData.uuid = results.response
  next()

getOctobluToken = (session) =>
  builder.Prompts.text session, prompts.getMeshbluToken

setOctobluToken = (session, results, next) =>
  session.userData.token = results.response
  next()

authenticateWithMeshblu = (session, results, next) =>
  { uuid, token } = session.userData
  meshbluHttp = new MeshbluHttp({uuid, token})
  meshbluHttp.whoami (error, deviceData) =>
    if (error)
      session.endDialog "Authorization failed with your uuid and token combination"
    else
      session.send "Successfully logged in"

getMyDevices = (session, results, next) =>
  { uuid, token } = session.userData
  meshbluHttp = new MeshbluHttp {uuid, token}
  meshbluHttp.myDevices {}, (error, deviceResults) =>
    session.endDialog "Sorry could not find your devices" if error
    {devices} = deviceResults
    _.each devices, (device) ->
      session.send "Device:\n
      Name:#{device.name?}\n
      Type:#{device.type?}\n
      UUID:#{device.uuid}\n"
    session.userData.devices = devices
    next()

getName = (session, results, next) =>
  builder.Prompts.text session, prompts.getName

setName = (session, results, next) =>
  name = results.response if results.response.length?
  session.userData.name = name
  next()



dialog.onBegin (session, results, next) =>
  session.beginDialog '/BeginDialog' unless session.userData.name

dialog.on 'Help', showHelp
dialog.on 'SetCredentials', [getOctobluUUID, setOctobluUUID, getOctobluToken, setOctobluToken, authenticateWithMeshblu]
dialog.on 'MyDevices', [authenticateWithMeshblu, getMyDevices]
dialog.on 'None', builder.DialogAction.send prompts.intentNotFound
dialog.onDefault builder.DialogAction.send(prompts.intentNotFound)

module.exports = dialog
