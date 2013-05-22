q = require("q")
_ = require("underscore")
fs = require('fs')
xmlParser = require("xmldom").DOMParser
gpx = require("./gpx")

readFile = (fileName) ->
  hasReadFile = q.defer()
  fs.readFile fileName, 'utf8', (err, contents) ->
    return hasReadFile.reject(err) if err?
    return hasReadFile.resolve(contents)
  hasReadFile.promise

class Trail
  constructor: (@path) ->


defaultLoadOptions = {}

parseIntoDom = (xml)-> new xmlParser().parseFromString(xml)
convertToLineString = (dom) -> gpx(dom).toLineString()
createTrail = (data) ->
  path = data[0]
  trail = new Trail(path)

module.exports.load = (options) ->
  options = _.extend({}, defaultLoadOptions, options)
  throw "A trail \"path\" is required" unless options.path?

  path = readFile(options.path, 'utf8')
    .then(parseIntoDom)
    .then(convertToLineString)
    .then((path) -> new Trail(path))

  q.all([path])
