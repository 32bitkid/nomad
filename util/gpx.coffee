xpath = require 'xpath'
latlon = require './latlon'

toGeoJSONPoint = (wpt) ->
  lat = parseFloat xpath.select("@lat",wpt)[0].value
  lon = parseFloat xpath.select("@lon",wpt)[0].value
  ele = parseFloat xpath.select("ele/text()",wpt).toString()
  [lat, lon, ele]

class Gpx
  constructor: (@dom) ->
    throw "An XML document is required" unless @dom?

  toLineString: ->
    coordinates = for wpt in xpath.select("//wpt|//trkpt", @dom)
      toGeoJSONPoint(wpt)

    {
      type: "LineString"
      coordinates: coordinates
    }

module.exports = (dom) ->
  new Gpx(dom)