LatLon = require('../util/latlon.coffee')
expect = require('chai').expect

describe "A LatLon", ->

  it "should have a latitude", ->
    coord = new LatLon(10,0)
    expect(coord.lat).to.equal(10)

  it "should have a longitude", ->
    coord = new LatLon(0,10)
    expect(coord.lon).to.equal(10)

  it "should require a latitude", ->
    noLat = -> new LatLon()
    expect(noLat).to.throw("Latitude cannot be undefined")

  it "should require a longitude", ->
    noLon = -> new LatLon(0)
    expect(noLon).to.throw("Longitude cannot be undefined")

  it "should accept an elevation", ->
    coord = new LatLon(0,0,1000)
    expect(coord.ele).to.equal(1000)

  describe "calculating distance between points", ->
    beforeEach ->
      dms = LatLon.dms
      @newYork = new LatLon(40.7142,-74.0064)
      @losAngeles = new LatLon(34.0522, -118.2428)

    it "should get the right distance from New York to Los Angeles", ->
      d = @newYork.distanceTo(@losAngeles)
      expect(Math.round(d)).to.equal(3936)

    it "should get the right distance from Los Angeles to New York", ->
      d = @losAngeles.distanceTo(@newYork)
      expect(Math.round(d)).to.equal(3936)

    it "should have a static comparison", ->
      d = LatLon.distanceBetween(@newYork, @losAngeles)
      expect(Math.round(d)).to.equal(3936)
