homeController = require './controllers/home'
home = new homeController

class Route
	constructor: (app) ->
		
		app.post '/api', home.post



module.exports = Route