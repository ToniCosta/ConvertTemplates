jsdom = require('jsdom')
fs = require('fs')
fsExtra = require('fs-extra')
prompt = require('prompt')
path = require('path')
glob = require('glob')
# toolbox = require('./classes/toolbox.js')

# box = new toolbox;


setPath = ->
    
    prompt.start();

    prompt.get(['PATHURL','AdServer'], (err, result) ->
        # console.log(result.AdServer)
        startConvert(result.PATHURL, result.AdServer)
        return
    
    )
    ####### Diretorio e Adserver automatico para desenvolvimento ######
    # pathURL = './templates/pecas_conversao/300x250'
    # adServer = 'admotion'

    # startConvert(pathURL, adServer)
    return

startConvert = (pathURL, adServer) ->
    switch adServer
        when 'admotion' then srcAdserver = 'templates/Admotion/Banner'; destAdserver = "#{pathURL}/#{adServer}"
        when 'atlas' then srcAdserver = 'templates/atlas'; destAdserver = "#{pathURL}/#{adServer}"

    fsExtra.copy srcAdserver, destAdserver, (err) ->
        if err
            return console.error(err)
        console.log 'success! paste'

        for extension in ['*.jpg','*.png','*.gif']
            glob "#{pathURL}/#{extension}", null, (err, files) ->

                if err
                    return console.error(err)
                for file in files
                    console.log file
                    fsExtra.copy file, "#{destAdserver}/custom/images/#{path.basename file}", (err) ->
                        if err
                            return console.error(err)

        htmlSource = fs.readFileSync("#{pathURL}/index.html", 'utf8')
        htmlSourceAdmotion = fs.readFileSync("#{destAdserver}/index.html", 'utf8')

        sourceTemplate = jsdom.jsdom(htmlSource,
            features:
                FetchExternalResources: [ 'script' ]
                ProcessExternalResources: [ 'script' ]
                MutationEvents: '2.0'
            parsingMode: 'auto')

        sourceTemplateAdmotion = jsdom.jsdom(htmlSourceAdmotion,
            features:
                FetchExternalResources: [ 'script' ]
                ProcessExternalResources: [ 'script' ]
                MutationEvents: '2.0'
            parsingMode: 'auto')

        jsdom.jQueryify sourceTemplate.defaultView, 'http://code.jquery.com/jquery.js', ->
            $ = sourceTemplate.defaultView.$
            contentBanner = $('#page1').parent().html()
            creativityWidth = $('#page1').attr('data-gwd-width')
            creativityHeight = $('#page1').attr('data-gwd-height')
            console.log creativityWidth
            cssBanner = $('style')
            
            fnc = ((css, banner) ->
                ->
                    $ = sourceTemplateAdmotion.defaultView.$
                    contentBannerAdmotion = $('#Creativity')
                    headerAdmotion = $('head')
                    bodyAdmotion = $('body')
                    bannerDimensions = $('#bannerDimensions')
                    bannerDimensions.html('
                        var adConfig = {};
                        adConfig.creativityWidth = "'+"#{creativityWidth}"+'";
                        adConfig.creativityHeight = "'+"#{creativityHeight}"+'";
                    ')
                    bannerDimensions.removeAttr 'id'
                    bodyAdmotion.append('
                        <script>
                        window.onload = function(){
                            var bannerOutput = document.getElementById("page1");
                            bannerOutput.firstElementChild.className += " gwd-play-animation";

                        }
                            
                        </script>
                    ')
                    
                    headerAdmotion.append(cssBanner);

                    contentBannerAdmotion.prepend contentBanner

                    replaceImg = $('img[is="gwd-image"]').each((index, data) ->
                        tag = $(data)
                        source = tag.attr('source')
                        tag.removeAttr 'is'
                        tag.removeAttr 'id'
                        tag.removeAttr 'source'
                        tag.attr 'src', 'custom/images/' + source
                        console.log tag[0].outerHTML
                        
                    )
                    removeScript = $('.jsdom')
                    removeScript.remove()
                  
                    fs.writeFile "#{destAdserver}/index.html", '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', (err) ->
                        if err
                            throw err
                        console.log 'Template Convertido com sucesso.'
                        return
                    return
            )(cssBanner, contentBanner)
            jsdom.jQueryify sourceTemplateAdmotion.defaultView, 'http://code.jquery.com/jquery.js', fnc
        return
      
setPath()
