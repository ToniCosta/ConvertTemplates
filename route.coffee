homeController = require './controllers/home'
home = new homeController
apiController = require './controllers/api'
api = new apiController

class Route
	constructor: (app) ->

    app.get '/', home.get
    app.get '/api', api.get

module.exports = Route