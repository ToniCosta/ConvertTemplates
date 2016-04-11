// Generated by CoffeeScript 1.10.0
var fs, fsExtra, glob, jsdom, path, prompt, setPath, startConvert;

jsdom = require('jsdom');

fs = require('fs');

fsExtra = require('fs-extra');

prompt = require('prompt');

path = require('path');

glob = require('glob');

setPath = function() {
  var adServer, pathURL;
  pathURL = 'C:/Users/costaan/Documents/GitHub/ConvertTemplates/templates/pecas_conversao/300x250';
  adServer = 'admotion';
  return startConvert(pathURL, adServer);
};

startConvert = function(pathURL, adServer) {
  var destAdserver, srcAdserver;
  if (adServer === 'admotion') {
    srcAdserver = 'templates/Admotion/Banner';
    destAdserver = "C:/Users/costaan/Documents/GitHub/ConvertTemplates/output/" + adServer;
  }
  if (adServer === 'atlas') {
    srcAdserver = 'templates/atlas';
    destAdserver = pathURL + '\\' + adServer;
  }
  fsExtra.copy(srcAdserver, destAdserver, function(err) {
    var extension, i, len, ref, results;
    if (err) {
      return console.error(err);
    }
    console.log('success! paste');
    ref = ['*.jpg', '*.png', '*.gif'];
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      extension = ref[i];
      results.push(glob(pathURL + "/" + extension, null, function(err, files) {
        var file, j, len1, results1;
        if (err) {
          return console.error(err);
        }
        results1 = [];
        for (j = 0, len1 = files.length; j < len1; j++) {
          file = files[j];
          console.log(file);
          results1.push(fsExtra.copy(file, destAdserver + "/custom/images/" + (path.basename(file)), function(err) {
            if (err) {
              return console.error(err);
            }
          }));
        }
        return results1;
      }));
    }
    return results;
  });
  return console.log(destAdserver);
};

setPath();
