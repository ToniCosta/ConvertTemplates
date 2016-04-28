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
  pathURL = './templates/pecas_conversao/300x250';
  adServer = 'admotion';
  startConvert(pathURL, adServer);
};

startConvert = function(pathURL, adServer) {
  var destAdserver, srcAdserver;
  switch (adServer) {
    case 'admotion':
      srcAdserver = 'templates/Admotion/Banner';
      destAdserver = "C:/Users/costaan/Documents/GitHub/ConvertTemplates/output/" + adServer;
      break;
    case 'atlas':
      srcAdserver = 'templates/atlas';
      destAdserver = pathURL + '\\' + adServer;
  }
  fsExtra.copy(srcAdserver, destAdserver, function(err) {
    var extension, htmlSource, htmlSourceAdmotion, i, len, ref, sourceTemplate, sourceTemplateAdmotion;
    if (err) {
      return console.error(err);
    }
    console.log('success! paste');
    ref = ['*.jpg', '*.png', '*.gif'];
    for (i = 0, len = ref.length; i < len; i++) {
      extension = ref[i];
      glob(pathURL + "/" + extension, null, function(err, files) {
        var file, j, len1, results;
        if (err) {
          return console.error(err);
        }
        results = [];
        for (j = 0, len1 = files.length; j < len1; j++) {
          file = files[j];
          console.log(file);
          results.push(fsExtra.copy(file, destAdserver + "/custom/images/" + (path.basename(file)), function(err) {
            if (err) {
              return console.error(err);
            }
          }));
        }
        return results;
      });
    }
    htmlSource = fs.readFileSync(pathURL + "/index.html", 'utf8');
    htmlSourceAdmotion = fs.readFileSync(destAdserver + "/index.html", 'utf8');
    sourceTemplate = jsdom.jsdom(htmlSource, {
      features: {
        FetchExternalResources: ['script'],
        ProcessExternalResources: ['script'],
        MutationEvents: '2.0'
      },
      parsingMode: 'auto'
    });
    sourceTemplateAdmotion = jsdom.jsdom(htmlSourceAdmotion, {
      features: {
        FetchExternalResources: ['script'],
        ProcessExternalResources: ['script'],
        MutationEvents: '2.0'
      },
      parsingMode: 'auto'
    });
    jsdom.jQueryify(sourceTemplate.defaultView, 'http://code.jquery.com/jquery.js', function() {
      var $, contentBanner, cssBanner, fnc;
      $ = sourceTemplate.defaultView.$;
      contentBanner = $('#page1').parent().html();
      cssBanner = $('style').each(function(el, data) {
        var cssBannerData;
        cssBannerData = $(data).html();
      });
      fnc = (function(css, banner) {
        return function() {
          var contentBannerAdmotion, headerAdmotion, replaceCss, replaceImg;
          $ = sourceTemplateAdmotion.defaultView.$;
          contentBannerAdmotion = $('#Creativity');
          headerAdmotion = $('head');
          headerAdmotion.append(cssBanner);
          contentBannerAdmotion.prepend(contentBanner);
          replaceCss = $('style').each(function(index, data) {
            var tagCss;
            tagCss = $(data);
            return console.log(tagCss);
          });
          replaceImg = $('img[is="gwd-image"]').each(function(index, data) {
            var source, tag;
            tag = $(data);
            source = tag.attr('source');
            tag.removeAttr('is');
            tag.removeAttr('source');
            tag.attr('src', 'custom/images/' + source);
            return console.log(tag[0].outerHTML);
          });
          fs.writeFile('output/admotion/index.html', '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', function(err) {
            if (err) {
              throw err;
            }
            console.log('Template Convertido com sucesso.');
          });
        };
      })(cssBanner, contentBanner);
      return jsdom.jQueryify(sourceTemplateAdmotion.defaultView, 'http://code.jquery.com/jquery.js', fnc);
    });
  });
  return console.log(destAdserver);
};

setPath();
