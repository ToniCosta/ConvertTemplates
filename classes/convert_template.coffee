jsdom = require 'jsdom'
fs = require 'fs'
fsExtra = require 'fs-extra'
prompt = require 'prompt'
glob = require 'glob'
path = require 'path'


class ConvertTemplate
    constructor: ->
    startMultipleConvertions: (vehicles) ->
        i = 0
        while i < vehicles.length
            vehicle = vehicles[i]
            @startConvert vehicle
            i++
        return
    startConvert: (adServer) ->
       
        switch adServer
            when 'htmlLimpo' then srcAdserver = './templates/html_limpo'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'abril' then srcAdserver = './templates/abril'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'admotion' then srcAdserver = './templates/Admotion/Banner'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}/custom/images/";
            when 'afilio' then srcAdserver = './templates/afilio'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";                
            when 'atlas' then srcAdserver = './templates/atlas_by_facebook'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'buscape' then srcAdserver = './templates/buscape'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'cbn' then srcAdserver = './templates/cbn'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dbcm' then srcAdserver = './templates/dbcm'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dcm_africa' then srcAdserver = './templates/dcm_africa'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dcm_africa_loop' then srcAdserver = './templates/dcm_africa_loop'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'dcStudio' then srcAdserver = './templates/dcm_africa_loop'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'estadao' then srcAdserver = './templates/estadao'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'gdnAdword' then srcAdserver = './templates/gdnAdword'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'globo' then srcAdserver = './templates/globo'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'ig' then srcAdserver = './templates/ig'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'infomoney' then srcAdserver = './templates/infomoney'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'mercadoEventos' then srcAdserver = './templates/mercadoEventos'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'mercadoLivre' then srcAdserver = './templates/mercadoLivre'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'msn' then srcAdserver = './templates/msn'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'nzn' then srcAdserver = './templates/nzn'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'r7' then srcAdserver = './templates/r7'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'sizmek' then srcAdserver = './templates/sizmek'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'smartclip' then srcAdserver = './templates/smartclip'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'sociomantic' then srcAdserver = './templates/sociomantic'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'techmundo' then srcAdserver = './templates/techmundo'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";
            when 'terra' then srcAdserver = './templates/terra'; destAdserver = "./convert/#{adServer}"; pathIMGS = "#{destAdserver}";


        fsExtra.copy srcAdserver, destAdserver, (err) ->
            if err
                return console.error(err)
            console.log 'success! paste'

            for extension in ['*.jpg','*.png','*.gif']
                glob "./uploads/#{extension}", null, (err, files) ->

                    if err
                        return console.error(err)
                    
                    for file in files
                        console.log file
                        fsExtra.copy file, "#{destAdserver}/#{path.basename file}", (err) ->
                            if err
                                return console.error(err)

            htmlSource = fs.readFileSync("./uploads/index.html", 'utf8')
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
                # cssBanner = $('style')
                # cssBanner = $('style').each((el,data)->
                #     console.log $(data).html()
                #     cssBannerContent = $(data).html()
                #     return
                
                # )
                cssBanner = $('style')
                contentCssBannerOveflow = cssBanner[4].outerHTML
                contentCssBanner = cssBanner[6].outerHTML
                elementClickTag = '<style>#clickTagArea{position:absolute; width:'+"#{creativityWidth}"+'; height:'+"#{creativityHeight}"+';left:0;top:0;cursor:pointer;}</style>'
                # console.log contentCssBanner
                
                fnc = ((css, banner) ->
                    ->
                        $ = sourceTemplate.defaultView.$
                        contentTemplate = $('body')

                        headerTemplate = $('head')
                        # console.log headerTemplate
                        bodyTemplate = $('body')
                        page = $('#page1')
                        page.addClass(' gwd-play-animation')
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
                        # console.log contentCssBanner
                        contentTemplate.prepend contentBanner


                        replaceImg = $('img[is="gwd-image"]').each((index, data) ->
                            tag = $(data)
                            source = tag.attr('source')
                            tag.removeAttr 'is'
                            tag.removeAttr 'id'
                            tag.removeAttr 'source'
                            # tag.attr 'src', 'custom/images/' + source
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
                            filePath = './uploads/';
                            rmDir = (dirPath) ->
                                try
                                    files = fs.readdirSync(dirPath)
                                catch e
                                    return
                                if files.length > 0
                                    i = 0
                                    while i < files.length
                                        filePath = dirPath + '/' + files[i]
                                        if fs.statSync(filePath).isFile()
                                            fs.unlinkSync filePath
                                        else
                                            rmDir filePath
                                        i++
                                fs.rmdirSync dirPath
                                return


                            rmDir(filePath)
                           

                        return
                   
                        
                        
                )(contentCssBanner, contentBanner)
                
                jsdom.jQueryify sourceTemplate.defaultView, 'http://code.jquery.com/jquery.js', fnc
                return
            return
        return  
module.exports = ConvertTemplate