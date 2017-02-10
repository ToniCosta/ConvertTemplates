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
mkdirp = require 'mkdirp'

class Compress
	constructor: ->
		@compress = new CompressImg

	post: (req,res) ->
		mkdirp 'uploads', (err) ->
        	if err
                console.error err
            else
                console.log 'Done!'
            return     
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
			if field == 'fields'
  				if fields['fields'] == undefined
    				fields['fields'] = []
  				fields['fields'].push value
				else
  					fields[field] = value
  			return

		form.on 'error', (err) ->
			console.log 'An error has occured: \n' + err
			return

		form.on 'end', ->
			
			res.write('received the data:\n\n');
			res.end util.inspect({fields: fields})
			# quality = field
			console.log fields
			console.log fields.typeFiles
			if fields.typeFiles == 'image/jpeg' || fields.typeFiles == 'image/png'
				console.log fields.fields
				compress.startImagemin(fields.fields, uuidRandon)
				console.log 'chama compressao de imagens'

			# if fields.typeFiles == 'text/html'
			# 	convert.startMultipleConvertions(fields.fields)
			# 	console.log 'chama conversor template'
			return
		

		form.parse req
		
		return	
		
module.exports = Compress
