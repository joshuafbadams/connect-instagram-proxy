
should = require 'should'
nock = require 'nock'
rewire = require 'rewire'
proxy = rewire '../src/connect-instagram-proxy'
firstPageMock = require './mocks/first-page-mock'
secondPageMock = require './mocks/second-page-mock'

mediaCache = proxy.__get__ 'mediaCache'

nock('https://api.instagram.com')
  .persist()
  .get('/v1/users/1/media/recent/?client_id=1')
  .reply(200, firstPageMock)
  .get('/v1/users/1/media/recent?max_id=823303733579372832_1514859117&client_id=1')
  .reply(200, secondPageMock)

describe 'connect-instagram-proxy', ->

  req = {}
  res = {}

  beforeEach ->
    req = {}
    res =
      setHeader: ->

  describe '#firstPage()', ->

    firstPage = proxy.firstPage

    afterEach ->
      mediaCache.flushAll()

    it 'should exist as a public function', (done) ->

      firstPage.should.be.a.Function
      done()

    it 'should throw an error if clientId parameter was not passed', (done) ->

      firstPage.bind(null).should.throw '"clientId" parameter is required'
      done()

    it 'should return a connect middleware function', (done) ->

      clientId = 1

      middleware = firstPage clientId
      middleware.should.be.a.Function
      done()

    it 'should respond from cache if instagram response is cached', (done) ->

      mediaCache.set 'firstPage', firstPageMock

      clientId = 1
      userId = 1

      middleware = firstPage clientId, userId
      middleware req, res, ->
        cacheStats = mediaCache.getStats()
        cacheStats.hits.should.equal 1
        req.instagram.firstPage.should.be.an.Object
        done()

    it 'should consult instagram API and cache response if not cached', (done) ->

      clientId = 1
      userId = 1

      middleware = firstPage clientId, userId
      middleware req, res, ->
        cacheStats = mediaCache.getStats()
        cacheStats.hits.should.equal 0
        req.instagram.firstPage.should.be.an.Object
        done()

  describe '#allPages()', ->

    allPages = proxy.allPages

    it 'should exist as a public function', (done) ->

      allPages.should.be.a.Function
      done()

    it 'should throw an error if clientId parameter was not passed', (done) ->

      allPages.bind(null).should.throw '"clientId" parameter is required'
      done()

    it 'should return a connect middleware function', (done) ->

      clientId = 1

      middleware = allPages clientId
      middleware.should.be.a.Function
      done()

    it 'should concatenate all pages in the instagram api', (done) ->

      clientId = 1
      userId = 1

      middleware = allPages clientId, userId
      middleware req, res, ->
        done()