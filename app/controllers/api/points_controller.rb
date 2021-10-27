class Api::PointsController < ApplicationController
  def create
    @tracker = Tracker.find_by(gps_id: tracker_params[:tracker_id])
    if @tracker
      @point = @tracker.points.create(record_time: point_params[:record_time], latlon: { lat: point_params[:lat], lon: point_params[:lng]})
      if @point.valid?
        render status: 201
      else
        render status: 422
      end
    else
      render status: 404
    end
  end

  def index
    @tracker = Tracker.find_by(gps_id: tracker_params[:tracker_id])
    if @tracker
      @points = @tracker.points
      render status: 200
    else
      render status: 404
    end
  end

  private

  def point_params
    params.require(:point).permit(:lat, :lng, :record_time)
  end

  def tracker_params
    params.permit(:tracker_id)
  end
end
