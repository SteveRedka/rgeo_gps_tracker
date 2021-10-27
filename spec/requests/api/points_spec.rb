require 'swagger_helper'

RSpec.describe 'api/points', type: :request do

  let!(:tracker) { create :tracker, gps_id: '123p', points_count: 3 }

  path '/api/trackers/{gps_id}/points' do
    parameter name: 'gps_id', in: :path, type: :string, description: 'gps_id'

    post('create point') do
      tags 'point'
      consumes 'application/json'
      parameter name: :point, in: :body, schema: {
        type: :object,
        properties: {
          tracker: {
            record_time: { type: 'string', format: 'date-time', required: 'true' },
            lat: { type: 'float', required: 'true' },
            lng: { type: 'float', required: 'true' }
          }
        }
      }

      response(201, 'point created') do
        let(:gps_id) { '123p' }
        let(:point) { { point: { lat: 35.7, lng: -114.1, record_time: Time.now } } }

        run_test! do
          response_json = JSON.parse(response.body)
          expect(response_json['point']['lat']).to eq(35.7)
          expect(response_json['point']['lng']).to eq(-114.1)
        end
      end

      response(422, 'invalid request') do
        let(:gps_id) { '123p' }
        let(:point) { { point: { record_time: Time.now } } }

        run_test!
      end

      response(404, 'tracker not found') do
        let(:gps_id) { 'undefined' }
        let(:point) { { point: { lat: 35.7, lng: -114.1, record_time: Time.now } } }
        run_test!
      end
    end

    get('list points') do
      response(200, 'successful') do
        let(:gps_id) { '123p' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test! do
          response_json = JSON.parse(response.body)
          tracker.points.each do |pt|
            expect(response.body).to match(pt.latlon[:lat].to_s)
            expect(response.body).to match(pt.latlon[:lng].to_s)
          end
        end
      end

      response(404, 'tracker not found') do
        let(:gps_id) { 'undefined' }
        run_test!
      end
    end
  end
end
