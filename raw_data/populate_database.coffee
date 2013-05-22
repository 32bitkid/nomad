mongo = require('mongodb')
q = require('q')

trail = require('../util/trail')

ct_options =
  id: "CT"
  name: "Colorado Trail"
  path: './raw_data/ct_full.gpx'

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

