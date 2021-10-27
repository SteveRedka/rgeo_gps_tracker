class Api::TrackersController < ApplicationController
  def create
    @tracker = Tracker.create(tracker_params)
    if @tracker.valid?
      render status: 201
    else
      render status: 422
    end
  end

  def index
    @trackers = Tracker.all
    render status: 200
  end

  def show
    @tracker = Tracker.find_by(gps_id: params[:gps_id])
    if @tracker
      render status: 200
    else
      render status: 404
    end
  end

  private

  def tracker_params
    params.require(:tracker).permit(:gps_id, :driver_initials, :vehicle_registration_id)
  end
end
