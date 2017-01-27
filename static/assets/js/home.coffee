target = document.querySelector('.target')
inputFile = document.getElementById('file')
pathURL = document.querySelector('.pathURL')
form = document.getElementById('convert')
modalCompressImg = document.getElementById('modalCompressImg')
modalTemplate = document.getElementById('modalTemplate')
btnFechar = document.getElementById('fechar')
btnFecharHTML = document.getElementById('fecharHTML')
form = document.getElementById('form')

handleBtnFechar = ->
	modalCompressImg.style.display = 'none';
	modalTemplate.style.display = 'none';
	return

handleFileSelect = (evt) ->
	evt.stopPropagation()
	evt.preventDefault()
	files = evt.dataTransfer.files
	output = []
	i = 0
	f = undefined
	while f = files[i]
		output.push '<strong>', escape(f.type), '</strong><br>'

		i++
		if escape(f.type) == 'text/html'
			console.log 'html'
			$('.progress').show()
			modalTemplate.style.display = 'block'
			
		else if escape(f.type) == 'image/jpeg' || escape(f.type) == 'image/png'
			console.log 'images'
			$('.progress').show()
			modalCompressImg.style.display = 'block'
			
		pathURL.innerHTML = output.join('')
	
	return


handleDragOver = (evt) ->
	evt.stopPropagation()
	evt.preventDefault()
	
	if evt.target.className == 'hover'
		return
	else
		evt.target.className += ' hover'
		evt.dataTransfer.dropEffect = 'copy'
	return

handleTarget = ->
	inputFile.click()
	return


handleInputFile = (evt) ->
	# pathSplit = inputFile.value.split('.')
	# pathURL.innerHTML = pathSplit[2]
	
	# pathURL.innerHTML = inputFile.value
	files = inputFile.files
	output = []
	i = 0
	f = undefined
	while f = files[i]
		output.push '<strong>', escape(f.type), '</strong><br>'

		i++
		if escape(f.type) == 'text/html'
			console.log 'html'
			typeFile = f.type
			$('.progress').show()
			modalTemplate.style.display = 'block'
			postFile(typeFile)
			
			
		else if escape(f.type) == 'image/jpeg' || escape(f.type) == 'image/png'
			console.log 'images'
			typeFile = f.type
			$('.progress').show()
			modalCompressImg.style.display = 'block'
			postFile(typeFile)
			
		pathURL.innerHTML = output.join('')

	return
	
target.addEventListener 'click', handleTarget, false
inputFile.addEventListener 'change', handleInputFile, false
target.addEventListener 'dragover', handleDragOver, false
target.addEventListener 'drop', handleFileSelect, false
btnFechar.addEventListener 'click', handleBtnFechar, false
btnFecharHTML.addEventListener 'click', handleBtnFechar, false

$('.progress-bar').text('0%');
$('.progress-bar').width('0%');

postFile = (typeFile) ->

	$("input[name='gender']").on 'click', ->
		
	  path = $("input[name='gender']:checked").val()
	  console.log (path)
	  files = $('#file').get(0).files
	  console.log (files)
	  if files.length > 0
	    # create a FormData object which will be sent as the data payload in the
	    # AJAX request
	    formData = new FormData
	    # loop through all the selected files and add them to the formData object
	    i = 0
	    while i < files.length
	      file = files[i]
	      # add the files to formData object for the data payload
	      formData.append 'files', file, file.name
	      i++
	    # $("input[name='vehicle']:checked").each ->
	    #   selected = []
	    #   selected.push $(this).val()
	    #   console.log selected
	    #   formData.append 'fields', selected
	    #   return
	    formData.append	'typeFiles', typeFile
	    
	    $.ajax
	      url: '/api'
	      type: 'POST'
	      data: formData
	      processData: false
	      contentType: false
	      success: (data) ->
	        console.log 'upload sucess!\n' + data
	        return
	      xhr: ->
	        # create an XMLHttpRequest
	        xhr = new XMLHttpRequest
	        # listen to the 'progress' event
	        xhr.upload.addEventListener 'progress', ((evt) ->
	          if evt.lengthComputable
	            # calculate the percentage of upload completed
	            percentComplete = evt.loaded / evt.total
	            percentComplete = parseInt(percentComplete * 100)
	            # update the Bootstrap progress bar with the new percentage
	            $('.progress-bar').text percentComplete + '%'
	            $('.progress-bar').width percentComplete + '%'
	            # once the upload reaches 100%, set the progress bar text to done
	            # if percentComplete == 100
	            #   # $('.progress-bar').html 'Upload'
	              
	          return
	        ), false
	        xhr
	  return

	$("#generate").on 'click', ->
		
	  # fields = $("input[name='vehicle']:checked").val()
	  fields = $("input[name='vehicle']:checked")
	  
	  files = $('#file').get(0).files
	  if files.length > 0
	    # create a FormData object which will be sent as the data payload in the
	    # AJAX request
	    formData = new FormData
	    # loop through all the selected files and add them to the formData object
	    
	    i = 0
	    while i < files.length
	      file = files[i]
	      # add the files to formData object for the data payload
	      formData.append 'files', file, file.name
	      i++
	    
	    j = 0
	    while j < fields.length
	      selected = fields[j].value      
	      console.log selected
	      formData.append "fields["+j+"]", selected
	      j++
	      
	    console.log formData
	    formData.append	'typeFiles', typeFile
	    $.ajax
	      url: '/api'
	      type: 'POST'
	      data: formData
	      processData: false
	      contentType: false
	      success: (data) ->
	        console.log 'upload sucess!\n' + data
	        return
	      xhr: ->
	        # create an XMLHttpRequest
	        xhr = new XMLHttpRequest
	        # listen to the 'progress' event
	        xhr.upload.addEventListener 'progress', ((evt) ->
	          if evt.lengthComputable
	            # calculate the percentage of upload completed
	            percentComplete = evt.loaded / evt.total
	            percentComplete = parseInt(percentComplete * 100)
	            # update the Bootstrap progress bar with the new percentage
	            $('.progress-bar').text percentComplete + '%'
	            $('.progress-bar').width percentComplete + '%'
	            # once the upload reaches 100%, set the progress bar text to done
	            # if percentComplete == 100
	            #   # $('.progress-bar').html 'Upload'
	              
	          return
	        ), false
	        xhr
	  return



