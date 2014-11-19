
/*
Module dependencies.
 */

(function() {
  var request;

  request = require('request');

  module.exports = function(clientId, userId) {
    if (userId == null) {
      userId = '';
    }
    if (clientId == null) {
      throw new Error('"clientId" parameter is required');
    }
    return function(req, res, next) {
      return request.get("https://api.instagram.com/v1/users/" + userId + "/media/recent/?client_id=" + clientId, function(err, response, body) {
        res.setHeader("Content-Type", "application/json");
        res.setHeader({
          "Access-Control-Allow-Origin": "*"
        });
        res.write(body);
        return res.end();
      });
    };
  };

}).call(this);
