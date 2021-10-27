require "rails_helper"

RSpec.describe GisOperations do
  let(:factory) { GisOperations.factory }

  describe "#self.factory" do
    it "creates a thing" do
      expect(factory).to be_a(RGeo::Geographic::Factory)
      expect(factory.srid).to eq 4326
    end
  end

  describe "#self.to_rgeo_point" do
    it "does something"
  end

  describe "#self.hash_to_point" do
    it "converts ruby-readable hashes into postgis-digestible points" do
      pt = GisOperations.hash_to_point(lat: 35.79282335, lng: -114.99325126)
      expect(pt).to be_a(RGeo::Geographic::SphericalPointImpl)
      expect(pt.to_s).to eq("POINT (-114.99325126 35.79282335)")
    end
  end

  describe "#self.distance_between_points" do
    it "measures distance between two points" do
      pt1 = GisOperations.hash_to_point(lat: 35.79282335, lng: -114.99325126)
      pt2 = GisOperations.hash_to_point(lat: 35.7930148, lng: -114.9821806)
      expect(GisOperations.distance_between_points(a: pt1, b: pt2)).to be_within(10).of(1000.0)
    end
  end

  describe "#self.track_distance" do
    # pt1 ------- 1 km --------- pt2
    #                             |
    #                             |
    #                             |
    #                            1 km
    #                             |
    #                             |
    #                             |
    #                             pt3
    let(:pt1) { GisOperations.hash_to_point(lat: 35.79282335, lng: -114.99325126) }
    let(:pt2) { GisOperations.hash_to_point(lat: 35.7930148, lng: -114.9821806) }
    let(:pt3) { GisOperations.hash_to_point(lat: 35.7839985, lng: -114.9820840) }

    it "measures distance between two points" do
      expect(GisOperations.track_distance([pt1, pt2])).to be_within(10).of(1000.0)
    end

    it "doesnt measure flight distance" do
      expect(GisOperations.track_distance([pt1, pt2, pt3])).not_to be_within(50).of(1414.2)
    end

    it "measures track distance between three points" do
      expect(GisOperations.track_distance([pt1, pt2, pt3])).to be_within(10).of(2000.0)
    end
  end

  describe "#direction_of_point" do
    before do
      @trckr = create :tracker, points_count: 0
      @first_point = create :point, tracker: @trckr, latlon: {lat: -45, lng: 35}, record_time: 30.minutes.ago
      @second_point = create :point, tracker: @trckr, latlon: {lat: -45, lng: 35}, record_time: 25.minutes.ago
    end

    coords_relative_to_zero_point = {
      E: {lat: -45, lng: 35.1},
      W: {lat: -45, lng: 34.9},
      N: {lat: -44.9, lng: 35},
      S: {lat: -45.1, lng: 35}
    }

    coords_relative_to_zero_point.each do |dir, latlon|
      it "outputs a cardinal direction of second point" do
        @second_point.update(latlon: latlon)
        expect(GisOperations.direction_of_point(a: @first_point.coords, b: @second_point.coords)).to eq(dir.to_s)
      end
    end
  end
end
