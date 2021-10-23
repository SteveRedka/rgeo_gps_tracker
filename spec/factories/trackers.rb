FactoryBot.define do
  factory :tracker do
    gps_id { "111" }
    driver_initials { "SNR" }
    vehicle_registration_id { "AA111CR" }
    transient do
      points_count { 0 }
    end
    after(:create) do |trckr, evaluator|
      lat = -122.1
      lon = 48.1

      evaluator.points_count.times do |i|
        create(:point, coords: "POINT(#{lat + i * 0.01} #{lon + i * 0.02})", record_time: 1.hour.ago + i.minutes,
                       tracker: trckr)
      end
    end
  end

  factory :tracker_with_isosceles_right_triangle_route, class: 'Tracker' do
    # pt1 ------- 1 km --------- pt2
    #                             |
    #                             |
    #                             |
    #                            1 km
    #                             |
    #                             |
    #                             |
    #                             pt3
    gps_id { "112" }
    driver_initials { "SNR" }
    vehicle_registration_id { "AA111CR" }
    after(:create) do |trckr|
      create(:point, latlon: { lat: 35.79282335, lng: -114.99325126 }, record_time: 3000.seconds.ago, tracker: trckr)
      create(:point, latlon: { lat: 35.7930148, lng: -114.9821806 }, record_time: 2000.seconds.ago, tracker: trckr)
      create(:point, latlon: { lat: 35.7839985, lng: -114.9820840 }, record_time: 1000.seconds.ago, tracker: trckr)
    end
  end
end
