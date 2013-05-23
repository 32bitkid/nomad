q = require('q')
fs = require 'fs'
sax = require 'sax'
latlon = require './latlon'
mongo = require('mongodb')

count = 0
tag = null
prevPoint = null
currentPoint = null

trails =
#  CT:
#    _id: mongo.ObjectID()
#    name: 'Colorado Trail'
#    description: 'Colorado\'s premier long distance trail, stretching almost 500 miles from Denver to Durango.'
#    homepage: 'http://www.coloradotrail.org/'
#    rawData: "./raw_data/CTR2013.gpx"
  AT:
    _id: mongo.ObjectID()
    name: 'Appalachian Trail'
    description: '2,200 miles (3,500 km) through Georgia, North Carolina, Tennessee, Virginia, West Virginia, Maryland, Pennsylvania, New Jersey, New York, Connecticut, Massachusetts, Vermont, New Hampshire, and Maine.'
    homepage: 'http://www.nps.gov/appa'
    rawData: "./raw_data/at_centerline_full.gpx"

pointsDone = q.defer()
trailsDone = q.defer()

mongoUri = 'mongodb://heroku_app15820215:em58r9ed9ha8r2hngghf4vnqeu@ds027348.mongolab.com:27348/heroku_app15820215';

mongo.Db.connect mongoUri, {safe: true}, (err, db) ->
	console.log(err) if (err)

	db.collection 'points', (er, collection) ->
		stream = sax.createStream(true, {lowercase: true, trim:true})
		stream.on 'opentag', (node) -> 
			tag = node.name
			if node.name=='trkpt'
				++count
				lat = parseFloat(node.attributes.lat)
				lon = parseFloat(node.attributes.lon)
				currentPoint = [lat, lon]
		stream.on 'text', (text) ->
			if tag=='ele'
				ele = parseFloat(text)
				currentPoint.push(ele)
		stream.on 'closetag', (name) ->
			tag = null
			if name=='trkpt' && currentPoint
				process prevPoint, currentPoint
				prevPoint = currentPoint
				currentPoint = null
		stream.on 'end', () ->
			console.log('Points read:', count)

		process = (prev, current) ->
			distanceFromPrev = if prev then latlon.distanceBetween(prev, current) else 0
			distanceFromStart = if prev then prev[4] + distanceFromPrev else 0
			current.push(distanceFromPrev, distanceFromStart)
			point = 
				trail: trails.AT._id
				distanceFromStart: distanceFromStart
				distanceFromPrevious: distanceFromPrev
				loc:
					type: "Point"
					coordinates: [current[0], current[1], current[2]]
			collection.insert(point, {safe:true})

		fs.createReadStream('./raw_data/at_centerline_full.gpx')
			.on 'end', () -> pointsDone.resolve()
			.pipe(stream)

	db.collection 'trails2', (er, collection) ->
		results = (val for key, val of trails)
		collection.insert(results, {safe:true}, (e) -> return pointsDone.reject(e) if e?; trailsDone.resolve())

	q.all([pointsDone.promise, trailsDone.promise]).done( -> console.log("done"); db.close() )






