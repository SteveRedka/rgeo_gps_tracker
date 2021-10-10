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
end
