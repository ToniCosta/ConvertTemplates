
class Home
	constructor: ->

	get: (req,res) ->
		res.writeHead(200, {'Content-Type': 'text/html'});
	
		res.write('teste');
		res.end();
		return

module.exports = Home
