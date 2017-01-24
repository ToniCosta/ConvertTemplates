jsdom = require 'jsdom'
fs = require 'fs'
fsExtra = require 'fs-extra'
prompt = require 'prompt'
glob = require 'glob'
path = require 'path'

class ConvertTemplate
    constructor: ->

    startConvert: (adServer) ->
        switch adServer
            when 'Admotion' then srcAdserver = './templates/Admotion/Banner'; destAdserver = "./convert/#{adServer}"
            when 'atlas' then srcAdserver = './templates/atlas'; destAdserver = "./convert/#{adServer}"

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
                        fsExtra.copy file, "#{destAdserver}/custom/images/#{path.basename file}", (err) ->
                            if err
                                return console.error(err)

            htmlSource = fs.readFileSync("./uploads/index.html", 'utf8')
            htmlSourceAdmotion = fs.readFileSync("#{destAdserver}/index.html", 'utf8')
            # console.log htmlSource
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
                # cssBanner = $('style')
                # cssBanner = $('style').each((el,data)->
                #     console.log $(data).html()
                #     cssBannerContent = $(data).html()
                #     return
                
                # )
                cssBanner = $('style')
                contentCssBanner = cssBanner[7].outerHTML
                # console.log contentCssBanner
                
                fnc = ((css, banner) ->
                    ->
                        $ = sourceTemplateAdmotion.defaultView.$
                        contentBannerAdmotion = $('#Creativity')

                        headerAdmotion = $('head')
                        console.log headerAdmotion
                        bodyAdmotion = $('body')
                        page = $('#page1')
                        page.addClass(' gwd-play-animation')
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
                        
                        headerAdmotion.append contentCssBanner

                        contentBannerAdmotion.prepend contentBanner

                        replaceImg = $('img[is="gwd-image"]').each((index, data) ->
                            tag = $(data)
                            source = tag.attr('source')
                            tag.removeAttr 'is'
                            tag.removeAttr 'id'
                            tag.removeAttr 'source'
                            tag.attr 'src', 'custom/images/' + source
                            console.log tag[0].outerHTML
                            return
                            
                        )
                        removeScript = $('.jsdom')
                        removeScript.remove()
                      
                        fs.writeFile "#{destAdserver}/index.html", '<html>' + contentBannerAdmotion.parents('html').html() + '</html>', (err) ->
                            if err
                                throw err
                            console.log 'Template Convertido com sucesso.'
                            return
                        return
                )(contentCssBanner, contentBanner)
                jsdom.jQueryify sourceTemplateAdmotion.defaultView, 'http://code.jquery.com/jquery.js', fnc
                return
            return
        return  
module.exports = ConvertTemplate