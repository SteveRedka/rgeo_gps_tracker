class Tracker < ApplicationRecord
  include GisOperations

  has_many :points

  validates :gps_id, :driver_initials, :vehicle_registration_id, presence: true

  # returns travel time in seconds
  def travel_time
    return 0 if points.count < 2

    points.last.record_time - points.first.record_time
  end

  # returns average speed in meters per second
  def average_speed(mode = "m/s")
    return 0 if points.count < 2

    if ["m/s", "mps"].include?(mode)
      track_distance / travel_time
    elsif ["km/h", "kph", "kmh", "kmph", "km/hr"].include?(mode)
      (track_distance / 1000) / (travel_time / 3600)
    else
      raise ArgumentError.new("unknown unit: #{mode}")
    end
  end

  def track_distance
    points = self.points.map { |pt| pt.coords }
    GisOperations.track_distance(points)
  end

  def movement_direction
    points_last_hour = points.where("record_time >= :date", date: 1.hour.ago)
    return "none" if points_last_hour.count < 2

    first_point = points_last_hour.first
    last_point = points_last_hour.last
    GisOperations.direction_of_point(a: first_point.coords, b: last_point.coords)
  end

  def time_moving_in_dominant_direction
    points_last_hour = points.where("record_time >= :date", date: 1.hour.ago)
    return 0 if points_last_hour.count < 2

    dominant_direction = movement_direction
    total_time = 0
    (1...points_last_hour.length).each do |i|
      pt1 = points_last_hour[i - 1]
      pt2 = points_last_hour[i]
      if GisOperations.direction_of_point(a: pt1.coords, b: pt2.coords) == dominant_direction
        total_time += pt2.record_time - pt1.record_time
      end
    end

    total_time
  end
end
