
debug = require('debug') 'httpware-always-html'
fs = require 'fs'
debounce = require('debounce')

alwaysHtml = (option = {})->
  debug 'alwaysHtml with', option
  throw new Error 'require `options.path`' unless option.path
  option.afterLoaded = option.afterLoaded || ()->
  option.debounce = option.debounce || 200
  cachedHtml = undefined

  loadHtml = ()->
    fs.readFile option.path,(err, html)->
      if err
        debug 'throw ', err
        throw err 
      cachedHtml = html
      debug 'cached html updated'
      option.afterLoaded() 

  fs.watch option.path, debounce(loadHtml, option.debounce)


  loadHtml()


  return (req, res, next)->
    debug 'alwaysHtml response', cachedHtml
    return next new Error 'not cached Html' unless cachedHtml
    res.writeHeader(200, {"Content-Type": "text/html"})
    res.write(cachedHtml)  
    res.end()


module.exports = alwaysHtml