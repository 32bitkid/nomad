var gpx = require('./util/gpx')
var fs = require('fs')
var xmlParser = require('xmldom').DOMParser

var waypoints = []
fs.readFile('./raw_data/ct_full.gpx', 'utf8', function (err, xml) {
	var dom = new xmlParser().parseFromString(xml)
	waypoints = gpx(dom).toJson()
})



var server = require('restify').createServer()

function respond(request, response, next) {
	response.send('Hello ' + (request.params.name || 'ambling rambler!'))
}
server.get('hello', respond)
server.get('hello/:name', respond)


server.get('waypoint/:index', waypoint)
function waypoint(request, response, next) {
	response.send(waypoints[request.params.index])
}


var port = process.env.PORT || 5000;
server.listen(port, function() {
	console.log("%s listening on %s", server.name, server.url)
})



var mongo = require('mongodb');

var mongoUri = process.env.MONGOLAB_URI ||
  process.env.MONGOHQ_URL ||
  'mongodb://heroku_app15820215:em58r9ed9ha8r2hngghf4vnqeu@ds027348.mongolab.com:27348/heroku_app15820215';

mongo.Db.connect(mongoUri, function (err, db) {
	console.log(err)
	db.collection('mydocs', function (er, collection) {
		collection.insert({ 'mykey': 'myvalue' }, { safe: true }, function (er, rs) {
		});
	});
});