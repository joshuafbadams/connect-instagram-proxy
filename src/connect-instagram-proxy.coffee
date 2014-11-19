###
Module dependencies.
###
request = require 'request'

module.exports = (clientId, userId = '') ->
  throw new Error '"clientId" parameter is required'

  return (req, res, next) ->

    request
      .get "https://api.instagram.com/v1/users/#{userId}/media/recent/?client_id=#{clientId}", (err, response, body) ->

        res.setHeader "Content-Type", "application/json"
        res.setHeader "Access-Control-Allow-Origin": "*"

        res.write body

        res.end()