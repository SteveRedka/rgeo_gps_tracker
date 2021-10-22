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
end
