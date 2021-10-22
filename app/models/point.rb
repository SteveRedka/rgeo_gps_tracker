class Point < ApplicationRecord
  include GisOperations

  belongs_to :tracker, optional: true

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
      self.coords = GisOperations.hash_to_point(arg)
    else
      self.coords = arg
    end
  end
end
