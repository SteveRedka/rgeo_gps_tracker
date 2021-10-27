require 'swagger_helper'

RSpec.describe 'api/trackers', type: :request do

  path '/api/trackers' do
    let(:tracker_params) { %i[gps_id driver_initials vehicle_registration_id average_speed travel_time
                              movement_direction time_moving_in_dominant_direction] }

    post('create tracker') do
      tags 'tracker'
      consumes 'application/json'
      parameter name: :tracker, in: :body, schema: {
        type: :object,
        properties: {
          tracker: {
            gps_id: { type: :string },
            driver_initials: { type: :string },
            vehicle_registration_id: { type: :string }
          }
        },
        required: { tracker: [:gps_id, :driver_initials, :vehicle_registration_id] }
      }
      response '201', 'tracker created' do
        let(:tracker) { { tracker: { gps_id: 'foo', driver_initials: 'bar', vehicle_registration_id: 'KR123A' } } }
        run_test! do |response|
          expect(Tracker.last.gps_id).to eq 'foo'
        end
      end

      context 'when tracker with this id already exists' do
        response '201', 'tracker created' do
          before do
            create :tracker, gps_id: 'overwrite', points_count: 1
          end
          let(:tracker) { { tracker: { gps_id: 'overwrite', driver_initials: 'bar', vehicle_registration_id: 'KR123A' } } }
          run_test! do |response|
            expect(Tracker.last.gps_id).to eq 'overwrite'
            expect(Tracker.last.driver_initials).to eq 'bar'
            expect(Tracker.last.points.count).to eq 0
            expect(Tracker.where(gps_id: 'overwrite').count).to eq 1
          end
        end
      end

      response '422', 'invalid request' do
        let(:tracker) { { gps_id: 'foo' } }
        run_test!
      end
    end

    get('list trackers') do
      tags 'tracker'
      response(200, 'successful') do
        before do
          @tracker_1 = create :tracker, points_count: 2, gps_id: 'first'
          @tracker_2 = create :tracker, points_count: 3, gps_id: 'second'
        end
        run_test! do |response|
          [@tracker_1, @tracker_2].each do |tr|
            tracker_params.each do |param|
              expect(response.body).to include(tr.send(param).to_s)
            end
          end
          # expect(response.body).to include(@tracker_1.gps_id)
          # expect(response.body).to include(@tracker_2.gps_id)
          # expect(response.body).to include(@tracker_1.travel_time.to_s)
          # expect(response.body).to include(@tracker_1.average_speed.to_s)
          # expect(response.body).to include(@tracker_1.movement_direction)
          # expect(response.body).to include(@tracker_1.time_moving_in_dominant_direction.to_s)
        end
      end
    end
  end

  path '/api/trackers/{gps_id}' do
    get('show tracker') do
      tags 'tracker'
      parameter name: :gps_id, in: :path, type: :string, description: 'id'

      before do
        @trckr = create :tracker, gps_id: '123', points_count: 2
      end

      response(200, 'successful') do
        schema type: :object,
          properties: {
            gps_id: { type: :string }
          },
          required: [ 'gps_id' ]
        let(:gps_id) { '123' }
        run_test! do |response|
          response_hash = JSON.parse(response.body)
          expect(response_hash['gps_id']).to eq(@trckr.gps_id)
          expect(response_hash['driver_initials']).to eq(@trckr.driver_initials)
          expect(response_hash['vehicle_registration_id']).to eq(@trckr.vehicle_registration_id)
        end
      end

      response(404, 'Tracker not found') do
        let(:gps_id) { '124' }
        run_test!
      end
    end
  end
end
