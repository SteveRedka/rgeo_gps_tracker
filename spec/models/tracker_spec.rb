require 'rails_helper'

RSpec.describe Tracker, type: :model do
  let (:tracker) { Tracker.new(gps_id: '111', driver_initials: 'SNR', vehicle_registration_id: 'AA111CR') }

  describe 'it responds to expected methods' do
    methods = %i[gps_id driver_initials vehicle_registration_id travel_time
                 average_speed track_distance movement_direction]
    methods.each do |mthd|
      it "responds to #{mthd}" do
        expect(tracker).to respond_to(mthd)
      end
    end
  end
end
