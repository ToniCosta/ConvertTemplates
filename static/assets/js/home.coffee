target = document.querySelector('.target')
inputFile = document.getElementById('file')
pathURL = document.querySelector('.pathURL')
form = document.getElementById('convert');

handleFileSelect = (evt) ->
	evt.stopPropagation()
	evt.preventDefault()
	files = evt.dataTransfer.files
	output = []
	i = 0
	f = undefined
	while f = files[i]
		output.push '<strong>', escape(f.name), '</strong><br>'
		i++
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
	# pathSplit = inputFile.value.split('\\')
	# pathURL.innerHTML = pathSplit[2]
	
	pathURL.innerHTML = inputFile.value
	return
	
	
target.addEventListener 'click', handleTarget, false
inputFile.addEventListener 'change', handleInputFile, false
target.addEventListener 'dragover', handleDragOver, false
target.addEventListener 'drop', handleFileSelect, false

	
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
	return
	sendRequest 'index.html', handleRequest

window.onload = () ->


