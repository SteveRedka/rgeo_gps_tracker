if @tracker
  if @point.valid?
    json.point do
      json.record_time @point.record_time
      json.lat @point.latlon[:lat]
      json.lng @point.latlon[:lon]
    end
  else
    json.(@point.errors.messages)
  end
else
  json.tracker do
    # json.gps_id 'Tracker not found'
  end
end
