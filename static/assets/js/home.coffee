target = document.querySelector('.target')
inputFile = document.getElementById('file')
pathURL = document.querySelector('.pathURL')

handleFileSelect = (evt) ->
	evt.stopPropagation()
	evt.preventDefault()
	files = evt.dataTransfer.files
	output = []
	i = 0
	f = undefined
	while f = files[i]
		output.push '<strong>', escape(f.name), '</strong>'
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

handleInputFile = ->
	pathSplit = inputFile.value.split('\\')
	pathURL.innerHTML = pathSplit[2]
	return

target.addEventListener 'click', handleTarget, false
inputFile.addEventListener 'onchange', handleTarget, false
target.addEventListener 'dragover', handleDragOver, false
target.addEventListener 'drop', handleFileSelect, false