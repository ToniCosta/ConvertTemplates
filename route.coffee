class Route
	constructor: (app) ->
    app.route.get '/', controller.get

module.exports = Route