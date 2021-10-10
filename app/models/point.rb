class Point < ApplicationRecord
  belongs_to :tracker

  def gps_id
    tracker.gps_id
  end

  def latitude
    # TODO
  end

  def longitude
    # TODO
  end
end
