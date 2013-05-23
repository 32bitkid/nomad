xpath = require 'xpath'
latlon = require './latlon'
q = require 'q'
fs = require 'fs'
readFile = q.nfbind(fs.readFile)
xmlParser = require("xmldom").DOMParser


toGeoJSONPoint = (wpt) ->
  lat = parseFloat xpath.select("@lat",wpt)[0].value
  lon = parseFloat xpath.select("@lon",wpt)[0].value
  ele = parseFloat xpath.select("ele/text()",wpt).toString()
  [lat, lon, ele]

addDistanceFromStart = (coords) ->
  previousPoint = coords[0]

  accumulator = 0

  for currentPoint, index in coords
    distanceToPrevious = latlon.distanceBetween(previousPoint, currentPoint)
    accumulator += distanceToPrevious
    currentPoint.push(distanceToPrevious)
    currentPoint.push(accumulator)
    previousPoint = currentPoint

class Gpx
  constructor: (@dom) ->
    throw "An XML document is required" unless @dom?

  toLineString: ->
    coordinates = for wpt in xpath.select("//trkpt", @dom)
      toGeoJSONPoint(wpt)

    addDistanceFromStart(coordinates)

    {
      type: "LineString"
      coordinates: coordinates
    }

  toPointArray: (id) ->
    coordinates = for wpt in xpath.select("//trkpt", @dom)
      toGeoJSONPoint(wpt)

    addDistanceFromStart(coordinates)

    for coord in coordinates
      { trail: id,  loc: {type: "Point", coordinates: coord }}

module.exports = (dom) ->
  new Gpx(dom)

module.exports.fromFile = (filename) ->
  readFile(filename, 'utf8')
    .then((xml)-> new xmlParser().parseFromString(xml))
    .then((dom) -> new Gpx(dom))