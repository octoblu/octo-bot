MSRest = require 'ms-rest'
botConfig = require '../config/bot-credentials'
auth = require 'basic-auth'

isAuthorized = (req) =>
  { appId, appSecret } = botConfig
  credentials          = new MSRest.BasicAuthenticationCredentials appId, appSecret
  requestCredentials = auth req
  console.log 'Request ', requestCredentials
  console.log 'Credentials', credentials
  return (
    requestCredentials?.name == credentials?.userName &&
    requestCredentials?.pass == credentials?.password
  )

module.exports = (req, res, next) =>
  return next() if isAuthorized req
  res.sendStatus(403)
