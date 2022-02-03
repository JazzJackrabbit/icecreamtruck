class Api::V1::TrucksController < Api::V1::ApiController
  include Api::V1::ModelPageable

  def show
    @truck = Truck.find(params[:id])
    render_template 'show', truck: @truck
  end

  def index
    page, per_page = sanitize_page_params(params)
    @trucks = Truck.all.page(page).per(per_page)
    add_pagination_data(@trucks, page, per_page)
    render_template 'index', trucks: @trucks
  end
end
