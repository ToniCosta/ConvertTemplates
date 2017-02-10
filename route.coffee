homeController = require './controllers/home'
home = new homeController
compressController = require './controllers/compress'
compress = new compressController

class Route
	constructor: (app) ->
		
		app.post '/api', home.post
		app.post '/compress', compress.post



module.exports = Route