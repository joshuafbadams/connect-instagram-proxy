
should = require 'should'
proxy = require '../dist/connect-instagram-proxy'

describe 'connect-instagram-proxy', ->

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

      middleware = firstPage(clientId)
      middleware.should.be.a.Function
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