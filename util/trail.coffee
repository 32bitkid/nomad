q = require("q")
_ = require("underscore")
fs = require('fs')
xmlParser = require("xmldom").DOMParser
gpx = require("./gpx")

readFile = q.nfbind(fs.readFile)

class Trail
  constructor: (@path) ->

defaultLoadOptions = {}

parseIntoDom = (xml)-> new xmlParser().parseFromString(xml)
convertToLineString = (dom) -> gpx(dom).toLineString()
createTrail = (path) ->
  trail = new Trail(path)

module.exports.load = (options) ->
  options = _.extend({}, defaultLoadOptions, options)
  throw "A trail \"path\" is required" unless options.path?

  path = readFile(options.path, 'utf8')
    .then(parseIntoDom)
    .then(convertToLineString)

  q.all([path]).spread(createTrail)
