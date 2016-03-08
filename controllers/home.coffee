class Home
	constructor: ->

	get: (req,res) ->
		res.send 'home'
		return

module.exports = Home
