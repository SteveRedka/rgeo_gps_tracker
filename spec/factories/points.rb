FactoryBot.define do
  factory :point do
    record_time { Time.now }
    coords { 'POINT(-122 47)' }
    tracker
  end
end
