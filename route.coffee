homeController = require './controllers/home'

class Route
	constructor: (app) ->

    app.get '/', homeController.get

module.exports = Route