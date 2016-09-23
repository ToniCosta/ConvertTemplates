CompressImg = require '../classes/compress_img'
fs = require 'fs'

class Home
	constructor: ->
		@compress = new CompressImg

	post: (req,res) ->
		res.writeHead(200);		
		
		# fs.readFile req.files.files.path, (err, data) ->
		# 	console.log data
	  		
		# 	if (err)
  #       	    res.status(500).send(err);
        
  #       	else
  #           	res.send('File uploaded!');

	 #  		newPath = __dirname + "/uploads/uploadedFileName"
		#   	fs.writeFile newPath, data, (err) ->
		#     	res.end()

module.exports = Home
