xpath = require 'xpath'

processPoint = (wpt) ->
  {
    lat: parseFloat xpath.select("@lat",wpt)[0].value
    lon: parseFloat xpath.select("@lon",wpt)[0].value
    ele: parseFloat xpath.select("ele/text()",wpt).toString()
    desc: xpath.select("desc/text()",wpt).toString()
  }

class Gpx
  constructor: (@dom) ->
    throw "An XML document is required" unless @dom?

  toJson: ->
    processPoint(wpt) for wpt in xpath.select("//wpt|//trkpt", @dom)

module.exports = (dom) ->
  new Gpx(dom)