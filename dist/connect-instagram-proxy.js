
/*
Module dependencies.
 */

(function() {
  var request, sendRequest, setHeaders;

  request = require('request');

  sendRequest = function(url, callback) {
    return request.get(url, callback);
  };

  setHeaders = function(res) {
    res.setHeader("Content-Type", "application/json");
    return res.setHeader("Access-Control-Allow-Origin", "*");
  };

  exports.firstPage = function(clientId, userId) {
    if (userId == null) {
      userId = '';
    }
    if (clientId == null) {
      throw new Error('"clientId" parameter is required');
    }
    return function(req, res, next) {
      return sendRequest("https://api.instagram.com/v1/users/" + userId + "/media/recent/?client_id=" + clientId, function(err, response, body) {
        var resObj;
        setHeaders(res);
        resObj = JSON.parse(body);
        res.write(JSON.stringify({
          data: resObj.data
        }));
        return res.end();
      });
    };
  };

  exports.allPages = function(clientId, userId) {
    if (userId == null) {
      userId = '';
    }
    if (clientId == null) {
      throw new Error('"clientId" parameter is required');
    }
    return function(req, res, next) {
      var callback, data;
      data = [];
      callback = function(err, response, body) {
        var paginationUrl, resObj;
        resObj = JSON.parse(body);
        paginationUrl = resObj.pagination['next_url'];
        data = data.concat(resObj.data);
        console.log('paginationurl:', paginationUrl);
        if (paginationUrl != null) {
          return sendRequest(paginationUrl, callback);
        } else {
          setHeaders(res);
          console.log(JSON.stringify({
            data: data
          }));
          res.write(JSON.stringify({
            data: data
          }));
          return res.end();
        }
      };
      return sendRequest("https://api.instagram.com/v1/users/" + userId + "/media/recent/?client_id=" + clientId, callback);
    };
  };

}).call(this);
