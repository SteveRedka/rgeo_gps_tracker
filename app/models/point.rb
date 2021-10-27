class Point < ApplicationRecord
  include GisOperations

  belongs_to :tracker, optional: true

  default_scope { order(record_time: :asc) }

  validates :coords, presence: true

  def gps_id
    tracker.gps_id
  end

  def latitude
    # TODO
  end

  def longitude
    # TODO
  end

  def latlon=(arg)
    if arg.is_a?(Hash)
      coords = arg.symbolize_keys
      if coords[:lat].blank? || (coords[:lng].blank? && coords[:lon].blank?)
        errors.add(:coords, message: "keys missing: #{arg} needs :lat and either :lng or :lon")
      else
        self.coords = GisOperations.to_rgeo_point(coords[:lat], (coords[:lng] || coords[:lon]))
      end
    elsif arg.is_a?(RGeo::Cartesian::PointImpl) || arg.is_a?(String)
      self.coords = arg
    else
      errors.add(:coords, message: "Wrong class for coords: #{arg.class}")
    end
  end

  def latlon
    {lat: coords.y, lon: coords.x}
  end
end
