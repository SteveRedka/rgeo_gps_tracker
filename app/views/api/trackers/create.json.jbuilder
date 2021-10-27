if @tracker.valid?
  json.(@tracker, :id, :gps_id, :driver_initials, :vehicle_registration_id)
else
  json.(@tracker.errors.messages)
end
