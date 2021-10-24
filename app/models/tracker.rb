class Tracker < ApplicationRecord
  include GisOperations

  has_many :points

  # returns travel time in seconds
  def travel_time
    return 0 if points.count < 2

    points.last.record_time - points.first.record_time
  end

  # returns average speed in meters per second
  def average_speed(mode = 'm/s')
    return 0 if points.count < 2

    if ['m/s', 'mps'].include?(mode)
      track_distance / travel_time
    elsif ['km/h', 'kph', 'kmh', 'kmph', 'km/hr'].include?(mode)
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
    return 'none' if points_last_hour.count < 2

    first_point = points_last_hour.first
    last_point = points_last_hour.last
    GisOperations.direction_of_point(a: first_point, b: last_point)
  end
end
