CompressImg = require '../classes/compress_img'
ConvertTemplate = require '../classes/convert_template'	
fs = require 'fs'
formidable = require 'formidable'
path = require 'path'
util = require 'util'
uuid = require 'node-uuid'
compress = new CompressImg
convert = new ConvertTemplate
uuidRandon = uuid.v1()

class Home
	constructor: ->
		@compress = new CompressImg

	post: (req,res) ->
		fields = []

		form = new formidable.IncomingForm()

		form.multiples = true
		console.log uuidRandon
		form.uploadDir = path.join('./', '/uploads')
		form.on 'fileBegin', (name, file) ->
			file.path = './uploads/' + file.name;
			console.log('Uploaded ' + file.name);

		form.on 'file', (name, file) ->
			# console.log('Uploaded ' + file.name);
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
			console.log fields.fields
			console.log fields.typeFiles
			# if fields.typeFiles == 'image/jpeg' || fields.typeFiles == 'image/png'

				# compress.startImagemin(fields.fields, uuidRandon)
				# console.log 'chama compressao de imagens'

			if fields.typeFiles == 'text/html'
				convert.startConvert(fields.fields)
				console.log 'chama conversor template'
			return
		

		form.parse req
		
		return	
		
module.exports = Home
