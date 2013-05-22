EARTH_RADIUS = 6371

class LatLon
  toRad = (val) -> val * Math.PI / 180;

  distanceBetween = (start, end, R = EARTH_RADIUS) ->
    lat1 = toRad(start.lat)
    lon1 = toRad(start.lon)
    lat2 = toRad(end.lat)
    lon2 = toRad(end.lon)
    dLat = lat2 - lat1;
    dLon = lon2 - lon1;

    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(lat1) * Math.cos(lat2) *
        Math.sin(dLon/2) * Math.sin(dLon/2);

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    R * c

  constructor: (@lat, @lon, @ele = 0, @radius) ->
    throw "Latitude cannot be undefined" unless @lat?
    throw "Longitude cannot be undefined" unless @lon?

  distanceTo: (other) ->
    distanceBetween(this, other, @radius)

  @distanceBetween = distanceBetween

module.exports = LatLon