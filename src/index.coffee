
debug = require('debug') 'httpware-always-html'
fs = require 'fs'
debounce = require('debounce')

emptyFn = ()->
alwaysHtml = (option = {}, done = emptyFn )->
  debug 'alwaysHtml with', option
  throw new Error 'require `options.path`' unless option.path 
  option.debounce = option.debounce || 200
  option.onRefresh = option.onRefresh || ()->
  cachedHtml = undefined

  loadHtml = (callback)->
    fs.readFile option.path,(err, html)->
      if err
        debug 'throw ', err
        throw err 
      cachedHtml = html
      debug 'cached html updated'
      callback()

  refreshHtml = ()->
    loadHtml ()->
      option.onRefresh()
  fs.watch option.path, debounce(refreshHtml, option.debounce)


  loadHtml done


  return (req, res, next)->
    debug 'alwaysHtml response', cachedHtml
    return next new Error 'not cached Html' unless cachedHtml
    res.writeHeader(200, {"Content-Type": "text/html"})
    res.write(cachedHtml)  
    res.end()


module.exports = alwaysHtml