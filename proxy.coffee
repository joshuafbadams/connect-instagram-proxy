request = require 'request'
http = require 'http'

server = http.createServer (req, res) ->

  request
    .get 'https://api.instagram.com/v1/users/1514859117/media/recent?client_id=4aa8f6eb2f5b436ca4182bb42dc401dd', (err, response, body) ->
      console.log body
      res.writeHead 200, "Content-Type": "application/json", "Access-Control-Allow-Origin": "*"
      res.write body
      res.end()

server.listen 3000, ->
  console.log 'Server listening on port 3000'
