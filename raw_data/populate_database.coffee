mongo = require('mongodb')
q = require('q')

trail = require('../util/trail')

ct_options =
  _id: "CT"
  name: 'Colorado Trail'
  description: 'Colorado’s premier long distance trail, stretching almost 500 miles from Denver to Durango.'
  homepage: 'http://www.coloradotrail.org/'
  path: './raw_data/CTR2013.gpx'

allTrails = q.all([trail.load(ct_options)])

allTrails.done (trails) ->
  mongo.Db.connect mongoUri, {safe: true}, (err, db) ->
    console.log(err) if (err)
    db.collection 'trails', (er, collection) ->
      collection.remove ->

        inserts = for t in trails
          q.ninvoke(collection, "insert", t, {safe: true})

        q.all(inserts).finally( -> db.close() ).done()



mongoUri = 'mongodb://localhost:27017/nomad';

