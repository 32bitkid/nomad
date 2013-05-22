When = require("when")
_ = require("underscore")
fs = require('fs')
xmlParser = require("xmldom").DOMParser
gpx = require("./gpx")

readFile = (fileName) ->
  hasReadFile = When.defer()
  fs.readFile fileName, 'utf8', (err, contents) ->
    return hasReadFile.reject(err) if err?
    return hasReadFile.resolve(contents)
  hasReadFile.promise

class Trail
  constructor: (@path) ->


defaultLoadOptions = {}

parseIntoDom = (xml)-> new xmlParser().parseFromString(xml)
gpxToJson = (dom) -> gpx(dom).toJson()
createTrail = (data) ->
  path = data[0]
  new Trail(path)

module.exports.load = (options) ->
  options = _.extend({}, defaultLoadOptions, options)
  throw "A trail \"path\" is required" unless options.path?

  path = readFile(options.path, 'utf8')
    .then(parseIntoDom)
    .then(gpxToJson)

  When.join(path).then(createTrail)

