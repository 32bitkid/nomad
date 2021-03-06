// Generated by CoffeeScript 1.6.2
(function() {
  var EARTH_RADIUS, LatLon;

  EARTH_RADIUS = 6371;

  LatLon = (function() {
    var distanceBetween, toRad;

    toRad = function(val) {
      return val * Math.PI / 180;
    };

    distanceBetween = function(start, end, R) {
      var a, c, dLat, dLon, lat1, lat2, lon1, lon2;

      if (R == null) {
        R = EARTH_RADIUS;
      }
      lat1 = toRad(start.lat || start[0]);
      lon1 = toRad(start.lon || start[1]);
      lat2 = toRad(end.lat || end[0]);
      lon2 = toRad(end.lon || end[1]);
      dLat = lat2 - lat1;
      dLon = lon2 - lon1;
      a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c;
    };

    function LatLon(lat, lon, ele, radius) {
      this.lat = lat;
      this.lon = lon;
      this.ele = ele != null ? ele : 0;
      if (this.lat == null) {
        throw "Latitude cannot be undefined";
      }
      if (this.lon == null) {
        throw "Longitude cannot be undefined";
      }
      if (radius != null) {
        this.radius = radius;
      }
    }

    LatLon.prototype.distanceTo = function(other) {
      return distanceBetween(this, other, this.radius);
    };

    LatLon.distanceBetween = distanceBetween;

    return LatLon;

  })();

  module.exports = LatLon;

}).call(this);
