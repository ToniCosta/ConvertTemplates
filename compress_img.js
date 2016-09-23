// $ npm i -D imagemin-pngquant
const gulp = require('gulp');
const imagemin = require('gulp-imagemin');
const pngquant = require('imagemin-pngquant');

function setLocale(){    
    
        var lowQuality = '5-15';
        var middleQuality = '50-65';
        var highQuality = '65-80';
        var defaultQuality = '90-100';
               
        switch (result.quality) {
            case 'low':
                result.quality = lowQuality;
            break;
            case 'middle':
                result.quality = middleQuality;
            break;            
            case 'high':
                result.quality = highQuality;
            break;
            default:
                result.quality = defaultQuality;
            break;
        }
        
        startImagemin(result.pathIMG,result.quality);
     
}

function startImagemin(callback, quality){
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
};

setLocale();
