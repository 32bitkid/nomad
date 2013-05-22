expect = require("chai").expect

dom = require('xmldom').DOMParser
_ = require('underscore')
gpx = require('../util/gpx.coffee')

describe "The GPX helper", ->

  it "should choke if you dont give it a file", ->
    noDocument = -> gpx()
    expect(noDocument).to.throw("An XML document is required")

  describe "converting to a LineString", ->

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
        @lineString = gpx(gpxData).toLineString()

      afterEach ->
        delete @lineString

      it "it should be a LineString", ->
        expect(@lineString.type).to.equal("LineString")

      it "get the correct length", ->
        expect(@lineString.coordinates.length).to.equal(3)

      it "should have the correct longitude", ->
        actual = _(@lineString.coordinates).pluck(1)
        expected = [-106.332433, -106.34085, -106.343467]
        expect(actual).to.deep.equal(expected)

      it "should parse the correct latitude", ->
        actual = _(@lineString.coordinates).pluck(0)
        expected = [39.075217, 39.077567, 39.077167]
        expect(actual).to.deep.equal(expected)

      it "should parse the correct elevation", ->
        actual = _(@lineString.coordinates).pluck(2)
        expected = [2809.3, 2808.8, 2809.6]
        expect(actual).to.deep.equal(expected)

    describe "with only 3 track points", ->

      xml = """
            <?xml version="1.0" standalone="yes"?>
            <gpx
              xmlns="http://www.topografix.com/GPX/1/0"
              version="1.0" creator="TopoFusion 3.26"
              xmlns:TopoFusion="http://www.TopoFusion.com"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.TopoFusion.com http://www.TopoFusion.com/topofusion.xsd">
             <url>http://www.topofusion.com</url>
             <urlname>TopoFusion Home Page</urlname>
            <bounds maxlat="45.904380" minlon="-84.199827" minlat="34.626564" maxlon="-68.921794"/>
            <trk>
             <url>http://www.topofusion.com</url>
             <urlname>TopoFusion Home Page</urlname>
              <trkseg>
                <trkpt lat="34.626686" lon="-84.193897">
                  <ele>1147.759277</ele>
                </trkpt>
                <trkpt lat="34.626703" lon="-84.193870">
                  <ele>1148.109985</ele>
                </trkpt>
                <trkpt lat="34.626750" lon="-84.193864">
                  <ele>1147.943848</ele>
                </trkpt>
              </trkseg>
            </trk>
            </gpx>
            """

      beforeEach ->
        gpxData = new dom().parseFromString(xml)
        @lineString = gpx(gpxData).toLineString()

      afterEach ->
        delete @lineString

      it "it should be a LineString", ->
        expect(@lineString.type).to.equal("LineString")

      it "get the correct length", ->
        expect(@lineString.coordinates.length).to.equal(3)

      it "should parse the correct longitude", ->
        actual = _(@lineString.coordinates).pluck(1)
        expected = [-84.193897, -84.193870, -84.193864]
        expect(actual).to.deep.equal(expected)

      it "should parse the correct latitude", ->
        actual = _(@lineString.coordinates).pluck(0)
        expected = [34.626686, 34.626703, 34.626750]
        expect(actual).to.deep.equal(expected)

      it "should parse the correct elevation", ->
        actual = _(@lineString.coordinates).pluck(2)
        expected = [1147.759277, 1148.109985, 1147.943848]
        expect(actual).to.deep.equal(expected)