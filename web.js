var _ = require('underscore')
var trail = require('./util/trail')

var waypoints = []
trail.load({ path: './raw_data/ct_full.gpx'}).then(function(trail) {
	waypoints = trail.path;
});

var restify = require('restify')
var server = restify.createServer()
server.use(
	function crossOrigin(req, res, next) {
		res.header("Access-Control-Allow-Origin", "*");
		res.header("Access-Control-Allow-Headers", req.header("Access-Control-Allow-Headers"));
		return next();
	}
)
server.get('waypoint/:index', waypoint)
function waypoint(request, response, next) {
	response.send(waypoints[request.params.index])
	return next()
}

server.get('trails', getTrails)
function getTrails(request, response, next) {
	var base = baseUrl(request)
	db('trails2', function (collection) {
		collection.find().toArray(function(err, results) {
			if (err) console.log(err)
			else response.send(_.map(results, function (trail) { return augmentTrail(trail, base) }))
		})
	})
	return next()
}

server.get('trails/:trailId', getTrail)
function getTrail(request, response, next) {
	var base = baseUrl(request)
	var key = new MongoID(request.params.trailId)
	db('trails2', function (collection) {
		collection.find(key).toArray(function (err, results) {
			if (err) console.log(err)
			else response.send(augmentTrail(results[0], base))
		})
	})
	return next()
}

function augmentTrail(trail, base) {
	trail.href = base + '/trails/' + trail._id
	trail.points = { href: base + '/points/' + trail._id }
	return trail
}

server.get("points/:trailId", getTrailPoints)
function getTrailPoints(request, response, next) {
	var base = baseUrl(request)
	var trailId = new MongoID(request.params.trailId)
	db('points', function (collection) {
		collection
			.find({ trail: trailId }, { exhaust: true })
			.sort('distanceFromStart')
			.batchSize(5000)
			.toArray(function (err, results) {
				if (err) console.log(err)
				else response.send(_.map(results, function (point) { return convertPoint(point, base) }))
			})
	})
	return next()
}

function convertPoint(point, base) {
	return {
		distanceFromStart: point.distanceFromStart,
		distanceFromPrevious: point.distanceFromPrevious,
		lat: point.loc.coordinates[0],
		long: point.loc.coordinates[1],
		elevation: point.loc.coordinates[2],
		trail: { href: base + '/trails/' + point.trail }
	}
}



function baseUrl(request) {
	if (!request) return ''
	var protocol = request.header('X-Forwarded-Proto') || 'http'
	var host = request.header('Host')
	return protocol + '://' + host
}



server.get('/\/.*/', restify.serveStatic({ directory: './sample', default: 'sample.html' }))


var port = process.env.PORT || 5000;
server.listen(port, function() {
	console.log("%s listening on %s", server.name, server.url)
})


var mongo = require('mongodb');
var MongoID = mongo.ObjectID

var mongoUri = process.env.MONGOLAB_URI ||
  process.env.MONGOHQ_URL ||
	'mongodb://heroku_app15820215:em58r9ed9ha8r2hngghf4vnqeu@ds027348.mongolab.com:27348/heroku_app15820215'

function db(collection, callback) {
	mongo.Db.connect(mongoUri, function (err, db) {
		if (err) console.log(err)
		else db.collection(collection, function (err, collection) {
			if (err) console.log(err)
			else callback(collection)
		})
	})
}