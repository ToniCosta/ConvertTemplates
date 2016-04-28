var rmdir = require( 'rmdir' );
var path  = 'templates/pecas_conversao/300x250/admotion';

rmdir( path , function ( err, dirs, files ){
  console.log( dirs );
  console.log( files );
  console.log( 'all files are removed' );
});

