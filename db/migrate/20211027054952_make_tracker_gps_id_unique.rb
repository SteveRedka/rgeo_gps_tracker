class MakeTrackerGpsIdUnique < ActiveRecord::Migration[6.0]
  def change
    add_index :trackers, :gps_id, unique: true
  end
end
