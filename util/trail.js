// Generated by CoffeeScript 1.6.2
(function() {
  var Trail, convertToLineString, createTrail, defaultLoadOptions, fs, gpx, parseIntoDom, q, readFile, xmlParser, _;

  q = require("q");

  _ = require("underscore");

  fs = require('fs');

  xmlParser = require("xmldom").DOMParser;

  gpx = require("./gpx");

  readFile = q.nfbind(fs.readFile);

  Trail = (function() {
    function Trail(path) {
      this.path = path;
    }

    return Trail;

  })();

  defaultLoadOptions = {};

  parseIntoDom = function(xml) {
    return new xmlParser().parseFromString(xml);
  };

  convertToLineString = function(dom) {
    return gpx(dom).toLineString();
  };

  createTrail = function(data) {
    var path, trail;

    path = data[0];
    return trail = new Trail(path);
  };

  module.exports.load = function(options) {
    var path;

    options = _.extend({}, defaultLoadOptions, options);
    if (options.path == null) {
      throw "A trail \"path\" is required";
    }
    path = readFile(options.path, 'utf8').then(parseIntoDom).then(convertToLineString).then(function(path) {
      return new Trail(path);
    });
    return q.all([path]);
  };

}).call(this);
