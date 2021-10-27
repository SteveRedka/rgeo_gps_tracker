if @tracker
  json.(@tracker, :id, :gps_id, :driver_initials, :vehicle_registration_id)
else
  json.tracker do
    json.gps_id 'Tracker not found'
  end
end
