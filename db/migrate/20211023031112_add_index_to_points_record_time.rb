class AddIndexToPointsRecordTime < ActiveRecord::Migration[6.0]
  def change
    add_index :points, :record_time
  end
end
