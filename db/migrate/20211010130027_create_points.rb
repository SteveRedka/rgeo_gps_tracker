class CreatePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|
      t.st_point :coords
      t.timestamp :record_time
      t.belongs_to :tracker

      t.timestamps
    end
  end
end
