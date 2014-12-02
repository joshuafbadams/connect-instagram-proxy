###
Module dependencies.
###
request = require 'request'

sendRequest = (url, callback) ->
  request
    .get url, callback

setHeaders = (res) ->
  res.setHeader "Content-Type", "application/json"
  res.setHeader "Access-Control-Allow-Origin", "*"

exports.firstPage = (clientId, userId = '') ->
  throw new Error '"clientId" parameter is required' if not clientId?

  return (req, res, next) ->

    req.instagram or= {}

    sendRequest "https://api.instagram.com/v1/users/#{userId}/media/recent/?client_id=#{clientId}", (err, response, body) ->
      setHeaders res
      resObj = JSON.parse body
      req.instagram.firstPage = resObj.data
      next()

exports.allPages = (clientId, userId = '') ->
  throw new Error '"clientId" parameter is required' if not clientId?

  return (req, res, next) ->

    data = []

    callback = (err, response, body) ->
      resObj = JSON.parse body
      paginationUrl = resObj.pagination['next_url']

      data = data.concat resObj.data
      console.log 'paginationurl:', paginationUrl

      if paginationUrl?
        sendRequest paginationUrl, callback
      else
        setHeaders res
        res.write JSON.stringify data: data
        res.end()

    sendRequest "https://api.instagram.com/v1/users/#{userId}/media/recent/?client_id=#{clientId}", callback
