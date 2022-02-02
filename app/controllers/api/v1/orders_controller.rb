class Api::V1::OrdersController < Api::V1::ApiController
  has_scope :by_truck, only: :index

  def show
    @order = Order.find(params[:id])
    render_template 'show', order: @order
  end

  def index
    @orders = apply_scopes(Order).order(created_at: :desc)
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
