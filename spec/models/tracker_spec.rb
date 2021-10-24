require "rails_helper"

RSpec.describe Tracker, type: :model do
  let(:tracker) { create :tracker, points_count: 5 }
  let(:empty_tracker) { create :tracker, points_count: 0 }
  let(:tracker_with_one_point) { create :tracker, points_count: 1 }
  let(:tracker_with_isosceles_right_triangle_route) { create :tracker_with_isosceles_right_triangle_route }
  let(:tracker_with_two_points_going_one_km_east) { create :tracker_with_two_points_going_one_km_east }

  describe "it responds to expected methods" do
    methods = %i[gps_id driver_initials vehicle_registration_id travel_time
      average_speed track_distance movement_direction time_moving_in_dominant_direction]
    methods.each do |mthd|
      it "responds to #{mthd}" do
        expect(tracker).to respond_to(mthd)
      end
    end
  end

  it "has points" do
    expect(tracker.points.count).to be > 1
    expect(tracker.points.first).to be_a Point
  end

  describe '#travel_time' do
    it "returns zero with no points" do
      expect(empty_tracker.travel_time).to eq 0
    end

    it "returns zero with one point" do
      expect(tracker_with_one_point.travel_time).to eq 0
    end

    it "measures travel time" do
      first_point = tracker.points.first
      last_point =  tracker.points.last
      expect(first_point.record_time).not_to eq last_point.record_time
      expect(tracker.travel_time).to eq last_point.record_time - first_point.record_time
    end
  end

  describe '#track_distance' do
    it 'sums distance between two points' do
      expect(tracker_with_two_points_going_one_km_east.track_distance).to be_within(10).of(1000.0)
    end

    it "sums distances between each pair of consecutive points" do
      expect(tracker_with_isosceles_right_triangle_route.track_distance).to be_within(10).of(2000.0)
    end

    it "tracks order of points by record_time, not other fields" do
      @trckr = create :tracker, points_count: 0
      create :point, tracker: @trckr, latlon: { lat: 35.7930148, lng: -114.9821806 }, record_time: 3000.seconds.ago
      create :point, tracker: @trckr, latlon: { lat: 35.79282335, lng: -114.99325126 }, record_time: 2000.seconds.ago
      create :point, tracker: @trckr, latlon: { lat: 35.792919075, lng: -114.98771593 }, record_time: 2500.seconds.ago
      expect(@trckr.track_distance).to be_within(10).of(1000.0)
    end
  end

  describe '#average_speed' do
    context "m/s" do
      it "returns zero with too few points" do
          expect(empty_tracker.average_speed).to eq 0
          expect(tracker_with_one_point.average_speed).to eq 0
      end

      context "two points" do
        it "measures average speed on track with two points" do
          expect(tracker_with_two_points_going_one_km_east.average_speed).to be_within(0.1).of(1.0)
        end

        it "measures average speed on track with more than two points" do
          trckr = tracker_with_isosceles_right_triangle_route
          expect(trckr.average_speed).to be_within(0.1).of(1.0)
          trckr.points.first.update(record_time: trckr.points.last.record_time - 5000.seconds)
          expect(trckr.average_speed).to be_within(0.1).of(0.5)
        end
      end
    end

    context 'km/h' do
      it "measures average speed on track with two points" do
        @tracker = create :tracker, points_count: 0
        create :point, tracker: @tracker, coords: "POINT(-114.9821806 35.7930148)",
                       record_time: 2.hours.ago
        create :point, tracker: @tracker, coords: "POINT(-114.99325126 35.79282335)",
                       record_time: @tracker.points.first.record_time + 1.hour
        expect(@tracker.average_speed('kmh')).to be_within(0.1).of(1.0)
      end
    end
  end

  describe '#movement_direction' do
    before do
      @trckr = create :tracker, points_count: 0
      create :point, tracker: @trckr, latlon: { lat: -45, lng: 35 }, record_time: 2.minutes.ago
      create :point, tracker: @trckr, latlon: { lat: -45, lng: 35 }, record_time: 1.minutes.ago
      @second_point = @trckr.points.last
      @zero_point = { lat: -45, lng: 35 }
    end

    it "outputs none if there are no points" do
      expect(empty_tracker.movement_direction).to eq 'none'
    end

    it "outputs none if there is only one point during last hour" do
      expect(tracker_with_one_point.movement_direction).to eq 'none'
    end

    it 'ignores data before last hour' do
      @tracker_with_old_pts = create :tracker, points_count: 0
      create :point, tracker: @trckr, latlon: { lat: -45, lng: 34 }, record_time: 2.hours.ago
      create :point, tracker: @trckr, latlon: { lat: -45.1, lng: 35 }, record_time: 1.minutes.ago
      expect(@tracker_with_old_pts.movement_direction).to eq 'none'
    end

    coords_relative_to_zero_point = {
      'E': { lat: -45, lng: 35.1 },
      'W': { lat: -45, lng: 34.9 },
      'N': { lat: -44.9, lng: 35 },
      'S': { lat: -45.1, lng: 35 }
    }

    coords_relative_to_zero_point.each do |dir, latlon|

      it "outputs a cardinal direction of tracker's movement while moving #{dir}" do
        @second_point.update(latlon: latlon)
        expect(@trckr.movement_direction).to eq(dir.to_s)
      end
    end

    it 'outputs diagonal directions'
  end

  describe '#time_moving_in_dominant_direction' do
    it 'returns zero if there is one or less points' do
      @trckr = create :tracker, points_count: 0
      expect(@trckr.time_moving_in_dominant_direction).to eq(0)
      create :point, tracker: @trckr, record_time: 5.minutes.ago
      expect(@trckr.time_moving_in_dominant_direction).to eq(0)
    end

    it "outputs time spent moving in dominant direction during last hour" do
      @trckr = create :tracker, points_count: 0
      create :point, tracker: @trckr, latlon: { lat: -45, lng: 35 }, record_time: 5.minutes.ago
      create :point, tracker: @trckr, latlon: { lat: -45.1, lng: 35.1 }, record_time: 4.minutes.ago
      create :point, tracker: @trckr, latlon: { lat: -45.2, lng: 35.1 }, record_time: 3.minutes.ago
      create :point, tracker: @trckr, latlon: { lat: -45.3, lng: 35.1 }, record_time: 2.minutes.ago
      expect(@trckr.time_moving_in_dominant_direction).to be_within(5.seconds).of(2.minutes)
    end

    it 'ignores data before last hour' do
      @trckr = create :tracker, points_count: 0
      create :point, tracker: @trckr, latlon: { lat: -45, lng: 35 }, record_time: 5.hours.ago
      create :point, tracker: @trckr, latlon: { lat: -45.1, lng: 35.1 }, record_time: 5.minutes.ago
      expect(@trckr.time_moving_in_dominant_direction).to eq(0)
    end
  end
end
