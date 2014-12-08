
/*
Module dependencies.
 */

(function() {
  var mediaCache, request, sendRequest, setHeaders;

  request = require('request');

  mediaCache = require('../config/cache-config');

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
      req.instagram || (req.instagram = {});
      return mediaCache.get('firstPage', function(err, value) {
        if (err) {
          return next(err);
        }
        if (value.firstPage) {
          req.instagram.firstPage = value.firstPage.data;
          return next();
        } else {
          return sendRequest("https://api.instagram.com/v1/users/" + userId + "/media/recent/?client_id=" + clientId, function(err, response, body) {
            var resObj;
            setHeaders(res);
            resObj = JSON.parse(body);
            mediaCache.set('firstPage', resObj);
            req.instagram.firstPage = resObj.data;
            return next();
          });
        }
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
        var pagination, paginationUrl, resObj;
        resObj = JSON.parse(body);
        pagination = resObj.pagination;
        paginationUrl = pagination['next_url'];
        data = data.concat(resObj.data);
        if (paginationUrl != null) {
          return sendRequest(paginationUrl, callback);
        } else {
          return next();
        }
      };
      return sendRequest("https://api.instagram.com/v1/users/" + userId + "/media/recent/?client_id=" + clientId, callback);
    };
  };

}).call(this);
