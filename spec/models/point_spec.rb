require "rails_helper"

RSpec.describe Point, type: :model do
  let(:point) { create :point }

  describe "it responds to expected methods" do
    methods = %i[latitude longitude record_time coords gps_id]
    methods.each do |mthd|
      it "responds to #{mthd}" do
        expect(point).to respond_to(mthd)
      end
    end
  end

  describe '#coords=' do
    it 'accepts hash as declaration' do
      coords = { lat: 35.79282335, lng: -114.99325126 }
      str = "POINT(-114.99325126 35.79282335)"

      pt_str = Point.create(coords: str)
      pt_coords = Point.create(latlon: coords)
      expect(pt_coords.coords).to eq pt_str.coords
    end
  end
end
