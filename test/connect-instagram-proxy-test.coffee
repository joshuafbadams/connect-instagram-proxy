
should = require 'should'
nock = require 'nock'
proxy = require '../dist/connect-instagram-proxy'
firstPageMock = require './mocks/first-page-mock'

nock('https://api.instagram.com')
  .get('/v1/users/1/media/recent/?client_id=1')
  .reply(200, firstPageMock)

describe 'connect-instagram-proxy', ->

  req = {}
  res = {}

  beforeEach ->
    req = {}
    res =
      setHeader: ->

  describe '#firstPage()', ->

    firstPage = proxy.firstPage

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

    it 'should insert instagram json response in the request object', (done) ->

      clientId = 1
      userId = 1

      middleware = firstPage clientId, userId
      middleware req, res, ->

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

      middleware = allPages(clientId)
      middleware.should.be.a.Function
      done()

      it 'should concatenate all pages in the instagram api'