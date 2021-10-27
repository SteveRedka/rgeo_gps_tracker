if @tracker.valid?
  json.call(@tracker, :id, :gps_id, :driver_initials, :vehicle_registration_id)
else
  json.call(@tracker.errors.messages)
end
