NodeCache = require 'node-cache'

ONE_HOUR = 60 * 60

module.exports = new NodeCache stdTTL: ONE_HOUR, checkperiod: 0