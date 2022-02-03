class Api::V1::OrdersController < Api::V1::ApiController
  include Api::V1::ModelPageable
  include Api::V1::MerchantAuthenticatable
  before_action :authenticate_merchant!, only: [:show, :index]

  # GET /api/v1/orders/:id
  def show
    @order = Order.find(params[:id])
    render_template 'show', order: @order
  end

  # GET /api/v1/trucks/:truck_id/orders
  def index
    page, per_page = sanitize_page_params(params)
    @orders = Order.includes(:truck).by_truck(params[:truck_id]).order(created_at: :desc).page(page).per(per_page)
    truck = @orders.first.truck
    add_pagination_data(@orders, page, per_page)
    render_template 'index', orders: @orders, truck: truck
  end

  # POST /api/v1/trucks/:truck_id/orders
  def create
    @order = Order.new(order_params)   
    if @order.save
      render_template 'response', { message: 'ENJOY!', order: @order }, status: :created
    else
      raise AppErrors::OrderErrors::FailedOrderError
    end
  end

  protected

  def order_params
    params.permit(:truck_id, items_attributes: [:product_id, :quantity])
  end
end
