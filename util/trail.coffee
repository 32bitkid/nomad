q = require("q")
_ = require("underscore")
fs = require('fs')
xmlParser = require("xmldom").DOMParser
gpx = require("./gpx")

readFile = q.nfbind(fs.readFile)

class Trail
  constructor: (options, @path) ->
    @name = options.name
    @_id = options.id
    @description = options.description
    @homepage = options.homepage


defaultLoadOptions = {}

parseIntoDom = (xml)-> new xmlParser().parseFromString(xml)
convertToLineString = (dom) -> gpx(dom).toLineString()
createTrail = (options, pathData) ->
  new Trail(options, pathData)

module.exports.load = (options) ->
  options = _.extend({}, defaultLoadOptions, options)
  throw "A trail \"path\" is required" unless options.path?

  path = readFile(options.path, 'utf8')
    .then(parseIntoDom)
    .then(convertToLineString)

  q.all([options, path]).spread(createTrail)
