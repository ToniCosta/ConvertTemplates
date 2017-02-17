CompressImg = require '../classes/compress_img'
ConvertTemplate = require '../classes/convert_template'	
fs = require 'fs'
formidable = require 'formidable'
path = require 'path'
util = require 'util'
uuid = require 'node-uuid'
compress = new CompressImg
convert = new ConvertTemplate

mkdirp = require 'mkdirp'

class Compress
	constructor: ->
		@compress = new CompressImg

	post: (req,res) ->
		uuidRandon = uuid.v1()
		mkdirp "uploads/#{uuidRandon}/", (err) ->
        	if err
                console.error err
            else
                console.log 'Done!'
            return     
		fields = []

		form = new formidable.IncomingForm()

		form.multiples = true
		console.log uuidRandon
		form.uploadDir = path.join('./', "./uploads/#{uuidRandon}/")
		form.on 'fileBegin', (name, file) ->
			file.path = "./uploads/#{uuidRandon}/" + file.name;
			# console.log('Uploaded ' + file.name);

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
			compress.startImagemin(fields.fields, uuidRandon)
			console.log 'chama compressao de imagens'
			return
		

		form.parse req
		
		return	
		
module.exports = Compress
