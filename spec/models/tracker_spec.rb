require "rails_helper"

RSpec.describe Tracker, type: :model do
  let(:empty_tracker) { create :tracker, points_count: 0 }
  let(:tracker_with_one_point) { create :tracker, points_count: 1 }
  let(:tracker) { create :tracker, points_count: 5 }
  let(:tracker_with_isosceles_right_triangle_route) { create :tracker_with_isosceles_right_triangle_route }

  describe "it responds to expected methods" do
    methods = %i[gps_id driver_initials vehicle_registration_id travel_time
      average_speed track_distance movement_direction]
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
      tracker = empty_tracker
      create :point, tracker: tracker, coords: "POINT(-114.9821806 35.7930148)", record_time: 2.hours.ago
      create :point, tracker: tracker, coords: "POINT(-114.99325126 35.79282335)", record_time: tracker.points.last.record_time + 1.hour
      expect(tracker.track_distance).to be_within(10).of(1000.0)
    end

    it "sums distances between each pair of consecutive points" do
      expect(tracker_with_isosceles_right_triangle_route.track_distance).to be_within(10).of(2000.0)
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
          tracker = empty_tracker
          create :point, tracker: tracker, coords: "POINT(-114.9821806 35.7930148)", record_time: 2.hours.ago
          create :point, tracker: tracker, coords: "POINT(-114.99325126 35.79282335)", record_time: tracker.points.last.record_time + 1000.seconds
          expect(tracker.average_speed).to be_within(0.1).of(1.0)
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
        tracker = empty_tracker
        create :point, tracker: tracker, coords: "POINT(-114.9821806 35.7930148)", record_time: 2.hours.ago
        create :point, tracker: tracker, coords: "POINT(-114.99325126 35.79282335)", record_time: tracker.points.last.record_time + 1.hour
        expect(tracker.average_speed('kmh')).to be_within(0.1).of(1.0)
      end
    end
  end

  describe '#movement_direction' do
    it "outputs a hash"

    it "outputs a cardinal direction of tracker's movement during last hour"

    it "outputs time spent moving in that direction during last hour"
  end

end
