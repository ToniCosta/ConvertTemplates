// Generated by CoffeeScript 1.10.0
var XMLHttpFactories, createXMLHTTPObject, form, handleDragOver, handleFileSelect, handleInputFile, handleRequest, handleTarget, inputFile, pathURL, sendRequest, target;

target = document.querySelector('.target');

inputFile = document.getElementById('file');

pathURL = document.querySelector('.pathURL');

form = document.getElementById('convert');

handleFileSelect = function(evt) {
  var f, files, i, output;
  evt.stopPropagation();
  evt.preventDefault();
  files = evt.dataTransfer.files;
  output = [];
  i = 0;
  f = void 0;
  while (f = files[i]) {
    output.push('<strong>', escape(f.name), '</strong><br>');
    i++;
    pathURL.innerHTML = output.join('');
  }
};

handleDragOver = function(evt) {
  evt.stopPropagation();
  evt.preventDefault();
  if (evt.target.className === 'hover') {
    return;
  } else {
    evt.target.className += ' hover';
    evt.dataTransfer.dropEffect = 'copy';
  }
};

handleTarget = function() {
  inputFile.click();
};

handleInputFile = function(evt) {
  pathURL.innerHTML = inputFile.value;
};

target.addEventListener('click', handleTarget, false);

inputFile.addEventListener('change', handleInputFile, false);

target.addEventListener('dragover', handleDragOver, false);

target.addEventListener('drop', handleFileSelect, false);

XMLHttpFactories = [
  function() {
    return new XMLHttpRequest;
  }, function() {
    return new ActiveXObject('Msxml2.XMLHTTP');
  }, function() {
    return new ActiveXObject('Msxml3.XMLHTTP');
  }, function() {
    return new ActiveXObject('Microsoft.XMLHTTP');
  }
];

sendRequest = function(url, callback, postData) {
  var method, req;
  req = createXMLHTTPObject();
  if (!req) {
    return;
  }
  method = postData ? 'POST' : 'GET';
  req.open(method, url, true);
  if (postData) {
    req.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
  }
  req.onreadystatechange = function() {};
  if (req.readyState !== 4) {
    return;
  }
  if (req.status !== 200 && req.status !== 304) {
    return;
  }
  callback(req);
  return;
  if (req.readyState === 4) {
    return;
  }
  req.send(postData);
};

createXMLHTTPObject = function() {
  var e, error, i, xmlhttp;
  xmlhttp = false;
  i = 0;
  while (i < XMLHttpFactories.length) {
    try {
      xmlhttp = XMLHttpFactories[i]();
    } catch (error) {
      e = error;
      i++;
      i++;
      continue;
    }
    break;
    i++;
  }
  return xmlhttp;
};

handleRequest = function(req) {
  var writeroot;
  writeroot = document.getElementsByClassName('pathURL');
  writeroot.innerHTML = req.responseText;
  return;
  return sendRequest('index.html', handleRequest);
};

window.onload = function() {};
