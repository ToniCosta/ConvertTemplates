jsdom = require('jsdom')
fs = require('fs')
htmlSource = fs.readFileSync('templates/generics/970x90/index.html', 'utf8')
htmlSourceAdmotion = fs.readFileSync('templates/admotion/970x90/index.html', 'utf8')
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
fsExtra.copy 'templates/generics/970x90/', 'templates/admotion/970x90/custom/images/', (err) ->
  if err
    return console.error(err)
  console.log 'success!'
  filePath = 'templates/admotion/970x90/custom/images/index.html'
  fs.unlinkSync filePath
  #remove HTML
  return
# copies file
jsdom.jQueryify doc.defaultView, 'http://code.jquery.com/jquery.js', ->
  #console.log('1');
  $ = doc.defaultView.$
  contentBanner = $('#page1').parent().html()
  cssBanner = $('style').each((el,data) ->
    
    # console.log 'cssbanner'
    # console.log(cssBannerDataReplace);
    # cssBannerData = $(data).html();    
    # cssBannerFind = '.gwd-play-animation'
    # cssBannerRegx = new RegExp(cssBannerFind,'g')
    # cssBannerDataReplace = cssBannerData.replace(cssBannerRegx, '')
    # cssBanner = $(this).html().replaceAll('.gwd-play-animation', '')
    # cssBanner = $(data).html();
    # console.log(cssBannerDataReplace);
    # console.log(cssBanner);
    return 

  )
  # console.log(contentBanner);
  # console.log(cssBanner);
  fnc = ((css, banner) ->
    ->
      #console.log('2');
      $ = doc2.defaultView.$
      contentBannerAdmotion = $('#Creativity')
      headerAdmotion = $('head');
      console.log(css,banner);
      
      headerAdmotion.append(cssBanner);

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
      fs.writeFile 'templates/admotion/970x90/convertido.html', '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', (err) ->
        if err
          throw err
        console.log 'Template Convertido com sucesso.'
        return
      return
  )(cssBanner, contentBanner)
  jsdom.jQueryify doc2.defaultView, 'http://code.jquery.com/jquery.js', fnc
  return