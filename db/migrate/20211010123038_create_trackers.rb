class CreateTrackers < ActiveRecord::Migration[6.0]
  def change
    create_table :trackers do |t|
      t.string :gps_id
      t.string :driver_initials
      t.string :vehicle_registration_id

      t.timestamps
    end
  end
end
