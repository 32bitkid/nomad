Trail = require('../util/trail.coffee')
expect = require('chai').expect

describe "Loading a trail", ->

  it "requires a path", ->
    noPathGiven = -> Trail.load()
    expect(noPathGiven).to.throw("A trail \"path\" is required")

  it "should load from a path to xml", (done) ->

    expected = (trail) ->
      expect(trail.path.coordinates.length).to.equal(1379)
      done()

    promise = Trail.load(path: "./raw_data/ct_full.gpx")
    promise.then(expected).fail(done)

