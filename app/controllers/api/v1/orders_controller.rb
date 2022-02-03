class Api::V1::OrdersController < Api::V1::ApiController
  include Api::V1::ModelPageable

  has_scope :by_truck, only: :index

  def show
    @order = Order.find(params[:id])
    render_template 'show', order: @order
  end

  def index
    page, per_page = sanitize_page_params(params)
    @orders = apply_scopes(Order).order(created_at: :desc).page(page).per(per_page)
    add_pagination_data(@orders, page, per_page)
    render_template 'index', orders: @orders
  end

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
