CompressImg = require '../classes/compress_img'
fs = require 'fs'
formidable = require 'formidable'
path = require 'path'
util = require 'util'
compress = new CompressImg

class Home
	constructor: ->
		@compress = new CompressImg

	post: (req,res) ->
		fields = []

		form = new formidable.IncomingForm()

		form.multiples = true

		form.uploadDir = path.join('./', '/uploads')
		form.on 'file', (field, file) ->
			fs.rename file.path, path.join(form.uploadDir, file.name)
			return
		form.on 'field', (field, value) ->
        	# console.log field
        	# console.log value
        	fields[field] = value
        	return
        	    

		form.on 'error', (err) ->
			console.log 'An error has occured: \n' + err
			return

		form.on 'end', ->
			res.write('received the data:\n\n');
			res.end util.inspect({fields: fields})
			# quality = field
			console.log(fields.fields)
			
			compress.startImagemin(fields.fields)
			return
		

		form.parse req
		
		return	
		
module.exports = Home
