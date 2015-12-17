WhitelistManager = require 'meshblu-core-manager-whitelist'
http             = require 'http'

class VerifyDiscoverAsWhitelist

  constructor: ({datastore, @whitelistManager, uuidAliasResolver}) ->
    @whitelistManager ?= new WhitelistManager {datastore, uuidAliasResolver}

  do: (job, callback) =>
    {auth, fromUuid, responseId} = job.metadata
    fromUuid ?= auth.uuid
    @whitelistManager.canDiscoverAs toUuid: fromUuid, fromUuid: auth.uuid, (error, canDiscoverAs) =>
      return @sendResponse responseId, 500, callback if error?
      return @sendResponse responseId, 403, callback unless canDiscoverAs
      @sendResponse responseId, 204, callback

  sendResponse: (responseId, code, callback) =>
    callback null,
      metadata:
        responseId: responseId
        code: code
        status: http.STATUS_CODES[code]

module.exports = VerifyDiscoverAsWhitelist
