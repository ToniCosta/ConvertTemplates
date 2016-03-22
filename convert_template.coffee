jsdom = require('jsdom')
fs = require('fs')
htmlSource = fs.readFileSync('generics/970x90/index.html', 'utf8')
htmlSourceAdmotion = fs.readFileSync('admotion/970x90/index.html', 'utf8')
fsExtra = require('fs-extra')
glob = require('glob')

doc = jsdom.jsdom(htmlSource,
  features:
    FetchExternalResources: [ 'script' ]
    ProcessExternalResources: [ 'script' ]
    MutationEvents: '2.0'
  parsingMode: 'auto')
doc2 = jsdom.jsdom(htmlSourceAdmotion,
  features:
    FetchExternalResources: [ 'script' ]
    ProcessExternalResources: [ 'script' ]
    MutationEvents: '2.0'
  parsingMode: 'auto')
fsExtra.copy 'generics/970x90/', 'admotion/970x90/custom/images/', (err) ->
  if err
    return console.error(err)
  console.log 'success!'
  filePath = 'admotion/970x90/custom/images/index.html'
  fs.unlinkSync filePath
  #remove HTML
  return
# copies file
jsdom.jQueryify doc.defaultView, 'http://code.jquery.com/jquery.js', ->
  #console.log('1');
  $ = doc.defaultView.$
  contentBanner = $('#page1').parent().html()
  cssBanner = $('style').each((el) ->
    # cssBanner = $(this).html();
    # console.log(cssBanner);
    return
  )
  # console.log(contentBanner);
  # console.log(cssBannerN);
  fnc = ((css, banner) ->
    ->
      $
      #console.log('2');
      $ = doc2.defaultView.$
      contentBannerAdmotion = $('#Creativity')
      # var headerAdmotion = $('head');
      # console.log(css,banner);
      # headerAdmotion.prepend(cssBanner);
      contentBannerAdmotion.prepend contentBanner
      replaceImg = $('img').each((index, data) ->
        tag = $(data)
        source = tag.attr('source')
        tag.removeAttr 'is'
        tag.removeAttr 'source'
        tag.attr 'src', 'custom/images/' + source
        # console.log('index '+ index,'data'+ data);
        console.log tag[0].outerHTML
        return
      )
      # console.log(headerAdmotion.html())
      # var str = '<img is="gwd-image" source="';
      # var replace = str.replace('<img is="gwd-image" source="','<img src="');
      # console.log("##" + replace);
      # console.log(contentBannerAdmotion.html());
      fs.writeFile 'admotion/970x90/template3.html', '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', (err) ->
        if err
          throw err
        console.log 'Template Convertido com sucesso.'
        return
      return
  )(cssBanner, contentBanner)
  jsdom.jQueryify doc2.defaultView, 'http://code.jquery.com/jquery.js', fnc
  return
