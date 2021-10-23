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
      raise ArgumentError.new('unknown unit')
    end
  end

  def track_distance
    points = self.points.map { |pt| pt.coords }
    GisOperations.track_distance(points)
  end

  def movement_direction
    # TODO
  end
end
