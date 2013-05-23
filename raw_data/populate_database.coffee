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
        q.ninvoke(collection, "insert", results).done( -> pointsDone.resolve())

  db.collection 'trails2', (er, collection) ->
    collection.remove ->
      q.ninvoke(collection, "insert", (val for key, val of trails)).done( -> trailsDone.resolve())

  q.all([pointsDone.promise, trailsDone.promise]).done( -> console.log("done"); db.close() )




