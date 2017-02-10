// Generated by CoffeeScript 1.10.0
var Compress, CompressImg, ConvertTemplate, compress, convert, formidable, fs, mkdirp, path, util, uuid, uuidRandon;

CompressImg = require('../classes/compress_img');

ConvertTemplate = require('../classes/convert_template');

fs = require('fs');

formidable = require('formidable');

path = require('path');

util = require('util');

uuid = require('node-uuid');

compress = new CompressImg;

convert = new ConvertTemplate;

uuidRandon = uuid.v1();

mkdirp = require('mkdirp');

Compress = (function() {
  function Compress() {
    this.compress = new CompressImg;
  }

  Compress.prototype.post = function(req, res) {
    var fields, form;
    mkdirp('uploads', function(err) {
      if (err) {
        console.error(err);
      } else {
        console.log('Done!');
      }
    });
    fields = [];
    form = new formidable.IncomingForm();
    form.multiples = true;
    console.log(uuidRandon);
    form.uploadDir = path.join('./', '/uploads');
    form.on('fileBegin', function(name, file) {
      file.path = './uploads/' + file.name;
      return console.log('Uploaded ' + file.name);
    });
    form.on('file', function(name, file) {
      fs.rename(file.path, path.join(form.uploadDir, file.name));
    });
    form.on('field', function(field, value) {
      if (field === 'fields') {
        if (fields['fields'] === void 0) {
          fields['fields'] = [];
        }
        fields['fields'].push(value);
      } else {
        fields[field] = value;
      }
    });
    form.on('error', function(err) {
      console.log('An error has occured: \n' + err);
    });
    form.on('end', function() {
      res.write('received the data:\n\n');
      res.end(util.inspect({
        fields: fields
      }));
      console.log(fields);
      console.log(fields.typeFiles);
      if (fields.typeFiles === 'image/jpeg' || fields.typeFiles === 'image/png') {
        console.log(fields.fields);
        compress.startImagemin(fields.fields, uuidRandon);
        console.log('chama compressao de imagens');
      }
    });
    form.parse(req);
  };

  return Compress;

})();

module.exports = Compress;