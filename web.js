var _ = require('underscore')
var trail = require('./util/trail')

var waypoints = []
trail.load({ path: './raw_data/ct_full.gpx'}).then(function(trail) {
	waypoints = trail.path;
});

var server = require('restify').createServer()
server.use(
	function crossOrigin(req, res, next) {
		res.header("Access-Control-Allow-Origin", "*");
		res.header("Access-Control-Allow-Headers", "X-Requested-With");
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
	db('trails', function (collection) {
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
	db('trails', function (collection) {
		collection.find(key).toArray(function (err, result) {
			if (err) console.log(err)
			else response.send(augmentTrail(result[0], base))
		})
	})
	return next()
}

function augmentTrail(trail, base) {
	trail.href = base + '/trails/' + trail._id
	return trail
}

function baseUrl(request) {
	if (!request) return ''
	var protocol = request.header('X-Forwarded-Proto') || 'http'
	var host = request.header('Host')
	return protocol + '://' + host
}




var port = process.env.PORT || 5000;
server.listen(port, function() {
	console.log("%s listening on %s", server.name, server.url)
})


var mongo = require('mongodb');
var MongoID = mongo.ObjectID

var mongoUri = process.env.MONGOLAB_URI ||
  process.env.MONGOHQ_URL ||
  'mongodb://heroku_app15820215:em58r9ed9ha8r2hngghf4vnqeu@ds027348.mongolab.com:27348/heroku_app15820215';

function db(collection, callback) {
	mongo.Db.connect(mongoUri, function (err, db) {
		if (err) console.log(err)
		else db.collection(collection, function (err, collection) {
			if (err) console.log(err)
			else callback(collection)
		})
	})
}


/*
mongo.Db.connect(mongoUri, function (err, db) {
	console.log(err)
	db.collection('trails', function (er, collection) {
		collection.insert({
			name: 'Colorado Trail',
			description: 'Colorado’s premier long distance trail, stretching almost 500 miles from Denver to Durango.',
			homepage: 'http://www.coloradotrail.org/'
		}, { safe: true }, function (er, rs) { })
		collection.insert({
			name: 'Appalachian Trail',
			description: '2,200 miles (3,500 km) through Georgia, North Carolina, Tennessee, Virginia, West Virginia, Maryland, Pennsylvania, New Jersey, New York, Connecticut, Massachusetts, Vermont, New Hampshire, and Maine.',
			homepage: 'http://www.nps.gov/appa'
		}, { safe: true }, function (er, rs) { })
	})
})
*/
