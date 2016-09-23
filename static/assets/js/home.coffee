target = document.querySelector('.target')
inputFile = document.getElementById('file')
pathURL = document.querySelector('.pathURL')
form = document.getElementById('convert')
modalCompressImg = document.getElementById('modalCompressImg')
modalTemplate = document.getElementById('modalTemplate')
btnFechar = document.getElementById('fechar')
btnFecharHTML = document.getElementById('fecharHTML')
form = document.getElementById('form')

cancelSubmit = ->
	console.log 'cancel form'
	return false
	
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
			modalTemplate.style.display = 'block'
			
		else if escape(f.type) == 'image/jpeg' || escape(f.type) == 'image/png'
			console.log 'images'
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
			modalTemplate.style.display = 'block'
			
			
		else if escape(f.type) == 'image/jpeg' || escape(f.type) == 'image/png'
			console.log 'images'
			modalCompressImg.style.display = 'block'
			
		pathURL.innerHTML = output.join('')

	return
	
target.addEventListener 'click', handleTarget, false
inputFile.addEventListener 'change', handleInputFile, false
target.addEventListener 'dragover', handleDragOver, false
target.addEventListener 'drop', handleFileSelect, false
btnFechar.addEventListener 'click', handleBtnFechar, false
btnFecharHTML.addEventListener 'click', handleBtnFechar, false
form.addEventListener 'submit', cancelSubmit


XMLHttpFactories = [
	->
		new XMLHttpRequest
	->
		new ActiveXObject('Msxml2.XMLHTTP')
	->
		new ActiveXObject('Msxml3.XMLHTTP')
	->
		new ActiveXObject('Microsoft.XMLHTTP')
]

sendRequest = (url, callback, postData) ->
	req = createXMLHTTPObject()
	if !req
		return
	method = if postData then 'POST' else 'GET'
	req.open method, url, true
	# req.setRequestHeader 'User-Agent', 'XMLHTTP/1.0'
	
	if postData
		req.setRequestHeader 'Content-type', 'application/x-www-form-urlencoded'

	req.onreadystatechange = ->
	if req.readyState != 4
		return
	if req.status != 200 and req.status != 304
		 # alert('HTTP error ' + req.status);
		return
	callback req
	return

	if req.readyState == 4
		return
	req.send postData
	return

createXMLHTTPObject = ->
	xmlhttp = false
	i = 0
	while i < XMLHttpFactories.length
		try
			xmlhttp = XMLHttpFactories[i]()
		catch e
			i++
			i++
			continue
		break
		i++
	xmlhttp

handleRequest = (req) ->
	writeroot = document.getElementsByClassName('pathURL');
	writeroot.innerHTML = req.responseText
	sendRequest 'index.html', handleRequest
	return

window.onload = ->
	cancelSubmit()