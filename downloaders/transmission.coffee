fs  = require 'fs'
api = require './transmission/api'

class Transmission
  _api: api

  get_session: ->
    @_api('session-get', {})
      .then( (result) ->
        if result.result is 'success'
          result.arguments
        else
          throw new Error result
      )

  add_torrent: (torrentPath, download_dir) ->
    torrentFileContent = fs.readFileSync torrentPath, {encoding: 'base64'}

    addData = {
      metainfo       : torrentFileContent
      paused         : no
      "download-dir" : download_dir
    }

    @_api("torrent-add", addData)
      .then( (result) ->
        if result.result is 'success'
          return result.arguments['torrent-added']
        else
          throw new Error result.result
      )

module.exports = Transmission