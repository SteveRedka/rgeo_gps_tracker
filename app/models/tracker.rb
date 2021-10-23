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

    second_point = points_last_hour.last
    first_point = points_last_hour.first
    x = second_point.coords.x - first_point.coords.x
    y = second_point.coords.y - first_point.coords.y
    atan = Math.atan2(x, y)
    if -0.7853981633974483 <= atan && 0.7853981633974483 >= atan
      dir = 'N'
    elsif 0.7853981633974483 <= atan && 2.356194490192345 >= atan
      dir = 'E'
    elsif -2.356194490192345 <= atan && -0.7853981633974483 >= atan
      dir = 'W'
    else
      dir = 'S'
    end
    return dir
  end
end
