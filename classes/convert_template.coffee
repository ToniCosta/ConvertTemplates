jsdom = require 'jsdom'
fs = require 'fs'
fsExtra = require 'fs-extra'
prompt = require 'prompt'
glob = require 'glob'
path = require 'path'
mkdirp = require 'mkdirp'


class ConvertTemplate
    constructor: ->
    startMultipleConvertions: (vehicles, uuid) ->
        i = 0
        while i < vehicles.length
            vehicle = vehicles[i]
            @startConvert vehicle, uuid
            i++
        return
        
    startConvert: (adServer, uuid) ->
          
        switch adServer
            when 'htmlLimpo' then srcAdserver = './templates/html_limpo'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'abril' then srcAdserver = './templates/abril'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'admotion' then srcAdserver = './templates/Admotion/Banner'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}/custom/images/";
            when 'afilio' then srcAdserver = './templates/afilio'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";                
            when 'atlas' then srcAdserver = './templates/atlas_by_facebook'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'buscape' then srcAdserver = './templates/buscape'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'cbn' then srcAdserver = './templates/cbn'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}"; 
            when 'dbcm' then srcAdserver = './templates/dbcm'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dbcm_loop' then srcAdserver = './templates/dbcm_loop'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dcm_africa' then srcAdserver = './templates/dcm_africa'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dcm_africa_loop' then srcAdserver = './templates/dcm_africa_loop'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dcStudio' then srcAdserver = './templates/DCStudio_banner'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'estadao' then srcAdserver = './templates/estadao'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'gdnAdword' then srcAdserver = './templates/gdnAdword'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'gdnAdword_loop' then srcAdserver = './templates/gdnAdword_loop'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'globo' then srcAdserver = './templates/globo'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'ig' then srcAdserver = './templates/ig'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'infomoney' then srcAdserver = './templates/infomoney'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'mercadoEventos' then srcAdserver = './templates/mercadoEventos'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'mercadoLivre' then srcAdserver = './templates/mercadoLivre'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'msn' then srcAdserver = './templates/msn'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'nzn' then srcAdserver = './templates/nzn'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'r7' then srcAdserver = './templates/r7'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'sizmek' then srcAdserver = './templates/sizmek'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'smartclip' then srcAdserver = './templates/smartclip'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'sociomantic' then srcAdserver = './templates/sociomantic'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'techmundo' then srcAdserver = './templates/techmundo'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'terra' then srcAdserver = './templates/terra'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'uol' then srcAdserver = './templates/uol'; destAdserver = "./convert/#{uuid}/#{adServer}"; pathIMGS = "#{destAdserver}";
        mkdirp "#{destAdserver}", (err) ->
            if err
                console.error err
            else
                console.log 'Done!'
            return  
        console.log destAdserver
        fsExtra.copy srcAdserver, destAdserver, (err) ->
            if err
                return console.error(err)
            console.log 'success! paste'

            for extension in ['*.jpg','*.png','*.gif']
                glob "./uploads/#{uuid}/#{extension}", null, (err, files) ->

                    if err
                        return console.error(err)
                    
                    for file in files
                        console.log file
                        if adServer == 'admotion'
                            fsExtra.copy file, "#{destAdserver}/custom/images/#{path.basename file}", (err) ->
                            if err
                                return console.error(err)
                        else
                            fsExtra.copy file, "#{destAdserver}/#{path.basename file}", (err) ->
                                if err
                                    return console.error(err)

            htmlSource = fs.readFileSync("./uploads/#{uuid}/index.html", 'utf8')
            htmlSourceTemplate = fs.readFileSync("#{destAdserver}/index.html", 'utf8')
            # console.log htmlSource
            sourceHTML = jsdom.jsdom(htmlSource,
                features:
                    FetchExternalResources: [ 'script' ]
                    ProcessExternalResources: [ 'script' ]
                    MutationEvents: '2.0'
                parsingMode: 'auto')

            sourceTemplate = jsdom.jsdom(htmlSourceTemplate,
                features:
                    FetchExternalResources: [ 'script' ]
                    ProcessExternalResources: [ 'script' ]
                    MutationEvents: '2.0'
                parsingMode: 'auto')

            jsdom.jQueryify sourceHTML.defaultView, 'http://code.jquery.com/jquery.js', ->
                $ = sourceHTML.defaultView.$

                contentBanner = $('#page1').parent().html()

                creativityWidth = $('#page1').attr('data-gwd-width')
                creativityHeight = $('#page1').attr('data-gwd-height')

                console.log creativityWidth
                console.log creativityHeight
                # cssBanner = $('style')
                # cssBanner = $('style').each((el,data)->
                #     console.log $(data).html()
                #     cssBannerContent = $(data).html()
                #     return
                
                # )
                urlDestino = $('gwd-exit').attr('url')
                console.log urlDestino
                cssBanner = $('style')
                contentCssBannerOveflow = "<style>#page1{overflow:hidden}</style>"
                
                # contentUrlDestino = '<script>var clickTag = "'+"#{urlDestino}"+'"</script>'
                # contentCssBanner = cssBanner[6].outerHTML
                cssBannerLength = cssBanner.length
                # console.log cssBannerLength
                l = 0
                while l < cssBannerLength
                    contentCssBanner = cssBanner[l].outerHTML
                    # console.log contentCssBanner
                    l++

                fnc = ((css, banner) ->
                    ->
                        $ = sourceTemplate.defaultView.$
                        

                        headerTemplate = $('head')
                        # console.log headerTemplate
                        if adServer == 'admotion'
                            contentTemplate = $('#Creativity')
                        if adServer == 'afilio'
                            elementClickTag = '<style>.clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('#BNafilio')
                            contentUrlDestino = '<script type="text/javascript">document.getElementById("BNafilio").addEventListener("click", function(){ var url = document.getElementById("afilio_tracker").setAttribute("href","'+urlDestino+'")});</script>'
                        if adServer == 'cbn'
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('body')
                            contentUrlDestino = '<script type="text/javascript">var clickTag = "'+urlDestino+'"</script>'
                        if adServer == 'dbcm' || adServer == 'dbcm_loop'
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('body')
                            contentUrlDestino = '<script type="text/javascript">var clickTag = "'+urlDestino+'"; var clickArea = document.getElementById("clickTagArea"); clickArea.onclick = function(){ window.open(clickTag, "_blank");}</script>'
                        if adServer == 'dcm_Africa' || adServer == 'dcm_Africa_loop'
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('body')
                            contentUrlDestino = '<script type="text/javascript">var clickTag = "'+urlDestino+'"; function openURL(){ window.open(window.clickTag);}</script>'
                        if adServer == 'dcStudio'
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('body')
                            contentUrlDestino = '<script type="text/javascript">var clickTag = "'+urlDestino+'";'
                        if adServer == 'nzn'
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('body')
                            contentUrlDestino = '<script type="text/javascript">var clickTag = "'+urlDestino+'";'
                        if adServer == 'smartclip'
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                            contentTemplate = $('body')
                            contentUrlDestino = '<script type="text/javascript">var url = document.getElementById("clickTagArea").setAttribute("href","'+urlDestino+'");</script>'
                        else
                            contentTemplate = $('body')
                            elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                        bodyTemplate = $('body')
                        page = $('#page1')
                        page.addClass(' gwd-play-animation')
                        if adServer == 'admotion'
                        
                            bannerDimensions = $('#bannerDimensions')
                            bannerDimensions.html('
                                var adConfig = {};
                                adConfig.creativityWidth = "'+"#{creativityWidth}"+'";
                                adConfig.creativityHeight = "'+"#{creativityHeight}"+'";
                            ')

                        #  /// ADMOTION SPECS
                        # bannerDimensions = $('#bannerDimensions')
                        # bannerDimensions.html('
                        #     var adConfig = {};
                        #     adConfig.creativityWidth = "'+"#{creativityWidth}"+'";
                        #     adConfig.creativityHeight = "'+"#{creativityHeight}"+'";
                        # ')
                        # bannerDimensions.removeAttr 'id'
                        bodyTemplate.append('
                            
                            <script>
                            window.onload = function(){
                                var bannerOutput = document.getElementById("page1");
                                bannerOutput.className += " gwd-play-animation";
                            }
                                
                            </script>
                        ')
                        
                        headerTemplate.append contentCssBannerOveflow
                        headerTemplate.append contentCssBanner
                        headerTemplate.append elementClickTag
                        # headerTemplate.prepend contentUrlDestino
                        
                        # console.log contentCssBanner
                        if adServer == 'nzn'
                            contentTemplate.prepend contentBanner
                            headerTemplate.append contentUrlDestino
                        else
                            contentTemplate.prepend contentBanner
                            bodyTemplate.append contentUrlDestino


                        replaceImg = $('img[is="gwd-image"]').each((index, data) ->
                            tag = $(data)
                            source = tag.attr('source')
                            tag.removeAttr 'is'
                            tag.removeAttr 'id'
                            tag.removeAttr 'source'
                            if adServer == 'admotion'
                                tag.attr 'src', 'custom/images/' + source
                            else
                                tag.attr 'src', source
                            # console.log tag[0].outerHTML
                            return
                            
                        )
                        removeScript = $('.jsdom')
                        removeScript.remove()
                        
                        bannerWidth = parseInt("#{creativityWidth}")
                        bannerHeight = parseInt("#{creativityHeight}")
                        
                        fs.writeFile "#{destAdserver}/index.html", '<html>' + contentTemplate.parents('html').html() + '</html>', (err) ->
                            if err
                                throw err
                            console.log 'Template Convertido com sucesso.'
                            
                            fs.rename "#{destAdserver}", "#{destAdserver}_#{bannerWidth}x#{bannerHeight}", (err) ->
                                if err
                                    throw err
                                console.log 'renamed complete'
                                return
                            # filePath = './uploads/';
                            # rmDir = (dirPath) ->
                            #     try
                            #         files = fs.readdirSync(dirPath)
                            #     catch e
                            #         return
                            #     if files.length > 0
                            #         i = 0
                            #         while i < files.length
                            #             filePath = dirPath + '/' + files[i]
                            #             if fs.statSync(filePath).isFile()
                            #                 fs.unlinkSync filePath
                            #             else
                            #                 rmDir filePath
                            #             i++
                            #     fs.rmdirSync dirPath
                            #     return


                            # rmDir(filePath)
                           

                        return
                   
                        
                        
                )(contentCssBanner, contentBanner)
                
                jsdom.jQueryify sourceTemplate.defaultView, 'http://code.jquery.com/jquery.js', fnc
                return
            return
        return  
module.exports = ConvertTemplate