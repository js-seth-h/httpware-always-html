request = require 'supertest'


describe 'always html', ()->

  flyway = require 'flyway'
  alwaysHtml = require '../src'
  http = require 'http'

  fs = require 'fs'

  fs.writeFileSync 'test/update.html', "Rev 1"

  doTest = undefined
  server = http.createServer flyway [
#      ... something you need
    alwaysHtml 
      path : 'test/update.html'
      onRefresh : ()->
        doTest()
    , ()->
        doTest()

  ] 
  agent = request.agent(server);


  it "sflywayuld send", (done)->
    doTest = ()->
        agent
          .get '/'
          .expect 'Rev 1'
          .expect 200, done


  it "sflywayuld update send", (done)->
    doTest = ()->
      agent
        .get '/'
        .expect 'Rev 2'
        .expect 200, done
    fs.writeFileSync 'test/update.html', "Rev 2"


