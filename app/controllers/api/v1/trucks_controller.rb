class Api::V1::TrucksController < Api::V1::ApiController
  include Api::V1::ModelPageable
  include Api::V1::MerchantAuthenticatable
  before_action :authenticate_merchant!, except: [:show, :index]

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
    @trucks = Truck.published.order(id: :asc).page(page).per(per_page)
    add_pagination_data(@trucks, page, per_page)
    render_template 'index', trucks: @trucks
  end

  # PUT /api/v1/trucks/:id
  def update
    @truck = Truck.find(params[:id])
    @truck.update(truck_params)
    render_template 'response', { message: 'Truck has been updated', truck: @truck }, status: :ok
  end

  # DELETE /api/v1/trucks/:id
  def destroy
    @truck = Truck.find(params[:id])
    @truck.archive!
    render json: { message: 'Truck has been permanently archived' }, status: :ok
  end

  protected

  def truck_params
    params.permit(:name)
  end
end
