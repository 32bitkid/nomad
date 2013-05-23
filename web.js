var trail = require('./util/trail')

var waypoints = []
trail.load({ path: './raw_data/ct_full.gpx'}).then(function(trail) {
	waypoints = trail.path;
});

var server = require('restify').createServer()

function respond(request, response, next) {
	response.send('Hello ' + (request.params.name || 'ambling rambler!'))
}
server.get('hello', respond)
server.get('hello/:name', respond)


server.get('waypoint/:index', waypoint)
function waypoint(request, response, next) {
	response.send(waypoints[request.params.index])
	return next()
}

server.get('trails', getTrails)
server.get('trails/:trailId', getTrail)

function getTrails(request, response, next) {
	response.send("Under Construction!")
	return next()
}

function getTrail(request, response, next) {
	response.send("Under Construction!")
	return next()
}




var port = process.env.PORT || 5000;
server.listen(port, function() {
	console.log("%s listening on %s", server.name, server.url)
})



var mongo = require('mongodb');

var mongoUri = process.env.MONGOLAB_URI ||
  process.env.MONGOHQ_URL ||
  'mongodb://heroku_app15820215:em58r9ed9ha8r2hngghf4vnqeu@ds027348.mongolab.com:27348/heroku_app15820215';


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