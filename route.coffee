homeController = require './controllers/home'
home = new homeController

class Route
	constructor: (app) ->
		app.get '/api', home.get


module.exports = Route