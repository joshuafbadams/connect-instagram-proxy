###
Module dependencies.
###
request = require 'request'
mediaCache = require '../config/cache-config'

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

    mediaCache.get 'firstPage', (err, value) ->
      return next(err) if err

      if value.firstPage
        req.instagram.firstPage = value.firstPage.data
        next()
      else
        sendRequest "https://api.instagram.com/v1/users/#{userId}/media/recent/?client_id=#{clientId}", (err, response, body) ->
          setHeaders res
          resObj = JSON.parse body
          mediaCache.set 'firstPage', resObj
          req.instagram.firstPage = resObj.data
          next()

exports.allPages = (clientId, userId = '') ->
  throw new Error '"clientId" parameter is required' if not clientId?

  return (req, res, next) ->
    data = []
    req.instagram or= {}

    mediaCache.get 'allPages', (err, value) ->
      return next(err) if err

      if value.allPages
        req.instagram.allPages = value.allPages.data
        next()
      else
        callback = (err, response, body) ->
          resObj = JSON.parse body
          pagination = resObj.pagination
          paginationUrl = pagination['next_url']

          data = data.concat resObj.data

          if paginationUrl?
            sendRequest paginationUrl, callback
          else
            dataObj = data: data
            mediaCache.set 'allPages', dataObj
            req.instagram.allPages = dataObj
            return next()

        sendRequest "https://api.instagram.com/v1/users/#{userId}/media/recent/?client_id=#{clientId}", callback

exports.firstTagPage = (accessToken) ->
  (req, res, next) ->

    tag = req.params.tag
    req.instagram or= {}

    mediaCache.get 'firstTagPage', (err, value) ->
      return next(err) if err

      if value.firstTagPage
        req.instagram.firstTagPage = value.firstTagPage.data
        next()
      else
        sendRequest "https://api.instagram.com/v1/tags/#{tag}/media/recent?access_token=#{accessToken}", (err, response, body) ->
          setHeaders res
          resObj = JSON.parse body
          mediaCache.set 'firstTagPage', resObj
          req.instagram.firstTagPage = resObj.data
          next()