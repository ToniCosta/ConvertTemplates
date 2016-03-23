// Generated by CoffeeScript 1.10.0
var doc, doc2, fs, fsExtra, glob, htmlSource, htmlSourceAdmotion, jsdom;

jsdom = require('jsdom');

fs = require('fs');

htmlSource = fs.readFileSync('templates/generics/970x90/index.html', 'utf8');

htmlSourceAdmotion = fs.readFileSync('templates/admotion/970x90/index.html', 'utf8');

fsExtra = require('fs-extra');

glob = require('glob');

doc = jsdom.jsdom(htmlSource, {
  features: {
    FetchExternalResources: ['script'],
    ProcessExternalResources: ['script'],
    MutationEvents: '2.0'
  },
  parsingMode: 'auto'
});

doc2 = jsdom.jsdom(htmlSourceAdmotion, {
  features: {
    FetchExternalResources: ['script'],
    ProcessExternalResources: ['script'],
    MutationEvents: '2.0'
  },
  parsingMode: 'auto'
});

fsExtra.copy('templates/generics/970x90/', 'templates/admotion/970x90/custom/images/', function(err) {
  var filePath;
  if (err) {
    return console.error(err);
  }
  console.log('success!');
  filePath = 'templates/admotion/970x90/custom/images/index.html';
  fs.unlinkSync(filePath);
});

jsdom.jQueryify(doc.defaultView, 'http://code.jquery.com/jquery.js', function() {
  var $, contentBanner, cssBanner, fnc;
  $ = doc.defaultView.$;
  contentBanner = $('#page1').parent().html();
  cssBanner = $('style').each(function(el) {
    cssBanner = $(this).html();
    console.log(cssBanner);
  });
  fnc = (function(css, banner) {
    return function() {
      $;
      var contentBannerAdmotion, headerAdmotion, replaceImg;
      $ = doc2.defaultView.$;
      contentBannerAdmotion = $('#Creativity');
      headerAdmotion = $('head');
      console.log(css, banner);
      headerAdmotion.prepend(cssBanner);
      contentBannerAdmotion.prepend(contentBanner);
      replaceImg = $('img').each(function(index, data) {
        var source, tag;
        tag = $(data);
        source = tag.attr('source');
        tag.removeAttr('is');
        tag.removeAttr('source');
        tag.attr('src', 'custom/images/' + source);
        console.log(tag[0].outerHTML);
      });
      fs.writeFile('templates/admotion/970x90/template5.html', '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', function(err) {
        if (err) {
          throw err;
        }
        console.log('Template Convertido com sucesso.');
      });
    };
  })(cssBanner, contentBanner);
  jsdom.jQueryify(doc2.defaultView, 'http://code.jquery.com/jquery.js', fnc);
});
