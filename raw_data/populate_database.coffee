mongo = require('mongodb')
q = require('q')
gpx = require('../util/gpx')
trails =
  CT:
    _id: mongo.ObjectID()
    name: 'Colorado Trail'
    description: 'Colorado\'s premier long distance trail, stretching almost 500 miles from Denver to Durango.'
    homepage: 'http://www.coloradotrail.org/'
    rawData: "./raw_data/CTR2013.gpx"
  AT:
    _id: mongo.ObjectID()
    name: 'Appalachian Trail'
    description: '2,200 miles (3,500 km) through Georgia, North Carolina, Tennessee, Virginia, West Virginia, Maryland, Pennsylvania, New Jersey, New York, Connecticut, Massachusetts, Vermont, New Hampshire, and Maine.'
    homepage: 'http://www.nps.gov/appa'
    rawData: "./raw_data/at_centerline_full.gpx"

points = []

mongoUri = 'mongodb://localhost:27017/nomad';

mongo.Db.connect mongoUri, {safe: true}, (err, db) ->
  console.log(err) if (err)

  pointsDone = q.defer()
  trailsDone = q.defer()

  db.collection 'points', (er, collection) ->
    collection.remove (err) ->
      gpx.fromFile("./raw_data/CTR2013.gpx").done (gpx) ->
        results = gpx.toPointArray(trails.CT._id)
        collection.insert(results, {safe: true}, (e) -> return pointsDone.reject(e) if e?; pointsDone.resolve())

  db.collection 'trails2', (er, collection) ->
    collection.remove ->
      results = (val for key, val of trails)
      collection.insert(results, {safe:true}, (e) -> return pointsDone.reject(e) if e?; trailsDone.resolve())

  q.all([pointsDone.promise, trailsDone.promise]).done( -> console.log("done"); db.close() )




