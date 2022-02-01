class Api::V1::TrucksController < Api::V1::ApiController
  def show
    @truck = Truck.find(params[:id])
    render_template 'show', truck: @truck
  end

  def index
    @trucks = Truck.all
    render_template 'index', trucks: @trucks
  end
end
