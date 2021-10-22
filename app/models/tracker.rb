class Tracker < ApplicationRecord
  include GisOperations

  has_many :points

  def travel_time
    return 0 if points.count < 2

    points.last.record_time - points.first.record_time
  end

  def average_speed
    return 0 if points.count < 2


  end

  def track_distance
    points = self.points.map { |pt| pt.coords }
    GisOperations.track_distance(points)
  end

  def movement_direction
    # TODO
  end
end
