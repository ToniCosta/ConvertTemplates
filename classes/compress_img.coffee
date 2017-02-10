gulp = require 'gulp'
imagemin = require 'gulp-imagemin'
pngquant = require 'imagemin-pngquant'

class CompressImg
	constructor: ->
	
	startImagemin: (quality, uuid) ->
		
		
		lowQuality = '5-15'
		middleQuality = '50-65'
		highQuality = '65-80'
		defaultQuality = '90-100'
		console.log quality[0]
		switch quality[0]
			when 'low' then quality = lowQuality	
			when 'middle' then quality = middleQuality
			when 'high' then quality = highQuality
			else
				quality = defaultQuality

		gulp.src('./uploads/*')
			.pipe(imagemin({
				progressive: true
				svgoPlugins: [
					{ removeViewBox: false }
					{ cleanupIDs: false }
				]
				use: [ pngquant({quality: quality, speed: 4})
				]})).pipe(gulp.dest("./compress/#{uuid}"))
	
module.exports = CompressImg