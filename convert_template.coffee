jsdom = require('jsdom')
fs = require('fs')
fsExtra = require('fs-extra')
prompt = require('prompt');

setPath = ->
    
    prompt.start();

    prompt.get(['PATHURL','AdServer'], (err, result) ->
        console.log(result.AdServer)
        startConvert(result.PATHURL, result.AdServer)
        return
    
    )

startConvert = (pathURL, adServer) ->
    
    if (adServer == 'admotion')
        destAdserver = pathURL+'\\'+adServer
        srcAdserver = 'templates/Admotion/Banner'
        console.log('admotion')
    if (adServer == 'atlas')
        srcAdserver = 'templates/atlas'
        destAdserver = pathURL+'\\'+adServer

        console.log('atlas')

    fsExtra.copy srcAdserver, destAdserver, (err) ->
        if err
            return console.error(err)
        console.log 'success! paste'
        
    console.log destAdserver


    # fsExtra.copy pathURL, destAdserver+'/custom/images/', (err) ->
    #     if err
    #         return console.error(err)
    #     console.log 'success! imgs'
    # filePath = destAdserver+'/custom/images/index.html'
    # fs.unlinkSync filePath
    # #remove HTML
    # return

    
    # htmlSource = fs.readFileSync(destAdserver + '/index.html', 'utf8')
    # htmlSourceAdmotion = fs.readFileSync('templates/admotion/970x90/index.html', 'utf8')

    # sourceTemplate = jsdom.jsdom(htmlSource,
    #     features:
    #         FetchExternalResources: [ 'script' ]
    #         ProcessExternalResources: [ 'script' ]
    #         MutationEvents: '2.0'
    #     parsingMode: 'auto')

    # sourceTemplateAdmotion = jsdom.jsdom(htmlSourceAdmotion,
    #     features:
    #         FetchExternalResources: [ 'script' ]
    #         ProcessExternalResources: [ 'script' ]
    #         MutationEvents: '2.0'
    #     parsingMode: 'auto')

    

    # jsdom.jQueryify sourceTemplate.defaultView, 'http://code.jquery.com/jquery.js', ->
    #     #console.log('1');
    #     $ = sourceTemplate.defaultView.$
    #     contentBanner = $('#page1').parent().html()
    #     cssBanner = $('style').each((el,data) ->
    
    #         # console.log 'cssbanner'
    #         # console.log(cssBannerDataReplace);
    #         # cssBannerData = $(data).html();    
    #         # cssBannerFind = '.gwd-play-animation'
    #         # cssBannerRegx = new RegExp(cssBannerFind,'g')
    #         # cssBannerDataReplace = cssBannerData.replace(cssBannerRegx, '')
    #         # cssBanner = $(this).html().replaceAll('.gwd-play-animation', '')
    #         # cssBanner = $(data).html();
    #         # console.log(cssBannerDataReplace);
    #         # console.log(cssBanner);
    #         return 

    #     )
    #     fnc = ((css, banner) ->
    #         ->
    #           #console.log('2');
    #             $ = sourceTemplateAdmotion.defaultView.$
    #             contentBannerAdmotion = $('#Creativity')
    #             headerAdmotion = $('head');
    #             console.log(css,banner);
              
    #             headerAdmotion.append(cssBanner);

    #             contentBannerAdmotion.prepend contentBanner
    #             replaceImg = $('img').each((index, data) ->
    #                 tag = $(data)
    #                 source = tag.attr('source')
    #                 tag.removeAttr 'is'
    #                 tag.removeAttr 'source'
    #                 tag.attr 'src', 'custom/images/' + source
    #                 # console.log('index '+ index,'data'+ data);
    #                 console.log tag[0].outerHTML
    #                 return
    #             )
    #           # console.log(headerAdmotion.html())
    #           # var str = '<img is="gwd-image" source="';
    #           # var replace = str.replace('<img is="gwd-image" source="','<img src="');
    #           # console.log("##" + replace);
    #           # console.log(contentBannerAdmotion.html());
    #             fs.writeFile 'templates/admotion/970x90/convertido.html', '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', (err) ->
    #                 if err
    #                     throw err
    #                 console.log 'Template Convertido com sucesso.'
    #                 return
    #             return
    #     )(cssBanner, contentBanner)
    #     jsdom.jQueryify sourceTemplateAdmotion.defaultView, 'http://code.jquery.com/jquery.js', fnc
    #     return
setPath()

