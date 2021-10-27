json.points @points do |pt|
  json.record_time pt.record_time
  json.lat pt.latlon[:lat]
  json.lng pt.latlon[:lon]

end
