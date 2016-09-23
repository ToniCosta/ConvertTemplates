gulp = require 'gulp'
imagemin = require 'gulp-imagemin'
pngquant = require 'imagemin-pngquant'

class CompressImg
	constructor: ->
	
	startImagemin: ->

		lowQuality = '5-15'
		middleQuality = '50-65'
		highQuality = '65-80'
		defaultQuality = '90-100'
		
		switch result.quality
			when 'low'
				result.quality = lowQuality	
			when 'middle'
				result.quality = middleQuality
			when 'high'
				result.quality = highQuality
			else
				result.quality = defaultQuality

		return gulp.src(callback+'/*')
		    .pipe(imagemin({
		        progressive: true,
		        svgoPlugins: [
		            {removeViewBox: false},
		            {cleanupIDs: false}
		        ],
		        use: [pngquant({quality: quality, speed: 4})]
		    }))
		    .pipe(gulp.dest(callback+'/compress'));
		
		


module.exports = CompressImg