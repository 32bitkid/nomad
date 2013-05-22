expect = require("chai").expect

dom = require('xmldom').DOMParser
gpx = require('../util/gpx')

describe "The GPX helper", ->

  it "should choke if you dont give it a file", ->
    noDocument = -> gpx()
    expect(noDocument).to.throw("An XML document is required")

  describe "processing a file", ->

    describe "with only 3 way points", ->

      xml = """
  <?xml version="1.0"?>
  <gpx creator="GPS Visualizer http://www.gpsvisualizer.com/" version="1.0" xmlns="http://www.topografix.com/GPX/1/0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd">
  <wpt lat="39.075217" lon="-106.332433">
    <ele>2809.3</ele>
    <time>2013-02-07T21:34:11Z</time>
    <name>01_000XX</name>
    <desc>Routes Split</desc>
  </wpt>
  <wpt lat="39.077567" lon="-106.34085">
    <ele>2808.8</ele>
    <time>2013-02-07T21:34:11Z</time>
    <name>01_005WT</name>
    <desc>Stream</desc>
  </wpt>
  <wpt lat="39.077167" lon="-106.343467">
    <ele>2809.6</ele>
    <time>2013-02-07T21:34:11Z</time>
    <name>01_007XX</name>
    <desc>InterLaken trail</desc>
  </wpt>
  </gpx>
  """

      beforeEach ->
        gpxData = new dom().parseFromString(xml)
        @gpx = gpx(gpxData)

      afterEach ->
        delete @gpx

      it "get the correct length", ->
        results = @gpx.toJson()
        expect(results.length).to.equal(3)
