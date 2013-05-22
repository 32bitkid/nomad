var restify = require('restify')

function respond(request, response, next) {
	response.send('Hello ' + (request.params.name || 'ambling rambler!'))
}

var server = restify.createServer()
server.get('hello', respond)
server.get('hello/:name', respond)

var port = process.env.PORT || 5000;
server.listen(port, function() {
	console.log("%s listening on %s", server.name, server.url)
})
