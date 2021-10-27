class Api::DebugController < ApplicationController
  def reset_db
    Tracker.destroy_all
    FactoryBot.create :tracker, points_count: 5
    FactoryBot.create :tracker, points_count: 7
    FactoryBot.create :tracker, points_count: 10
  end
end
