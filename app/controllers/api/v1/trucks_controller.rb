class Api::V1::TrucksController < Api::V1::ApiController
  include Api::V1::ModelPageable
  include Api::V1::MerchantAuthenticatable
  before_action :authenticate_merchant!, only: [:create, :update]

  # GET /api/v1/trucks/:id
  def show
    @truck = Truck.find(params[:id])
    render_template 'show', truck: @truck
  end

  # POST /api/v1/trucks
  def create
    @truck = Truck.new(truck_params)
    @truck.save!
    render_template 'show', { truck: @truck }, status: :created
  end

  # GET /api/v1/trucks
  def index
    page, per_page = sanitize_page_params(params)
    @trucks = Truck.all.page(page).per(per_page)
    add_pagination_data(@trucks, page, per_page)
    render_template 'index', trucks: @trucks
  end

  # PUT /api/v1/trucks/:id
  def update
    @truck = Truck.find(params[:id])
    @truck.update(truck_params)
    render_template 'response', { message: 'Truck has been updated', truck: @truck }, status: :ok
  end

  protected

  def truck_params
    params.permit(:name)
  end
end
