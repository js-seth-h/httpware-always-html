request = require 'supertest'


describe 'always html', ()->

  ho = require 'handover'
  alwaysHtml = require '../src/httpware-always-html'
  http = require 'http'

  fs = require 'fs'

  fs.writeFileSync 'test/update.html', "Rev 1"

  doTest = undefined
  server = http.createServer ho [
#      ... something you need
    alwaysHtml 
      path : 'test/update.html'
      afterLoaded: ()->
        doTest()

  ] 
  agent = request.agent(server);


  it "should send", (done)->
    doTest = ()->
        agent
          .get '/'
          .expect 'Rev 1'
          .expect 200, done


  it "should update send", (done)->
    fs.writeFileSync 'test/update.html', "Rev 2"
    doTest = ()->
      agent
        .get '/'
        .expect 'Rev 2'
        .expect 200, done


