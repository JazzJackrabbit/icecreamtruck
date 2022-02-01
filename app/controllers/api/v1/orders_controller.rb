class Api::V1::OrdersController < Api::V1::ApiController
  def create
    @order = Order.new(order_params)
    @order.add_items(product_list_params)    
    if @order.save
      render_template 'response', { message: 'ENJOY!', order: @order }, status: :created
    else
      raise AppErrors::OrderErrors::FailedOrderError
    end
  end

  protected

  def order_params
    params.permit(:truck_id)
  end

  def product_list_params
    params.permit(products: [:id, :quantity])[:products]
  end
end
