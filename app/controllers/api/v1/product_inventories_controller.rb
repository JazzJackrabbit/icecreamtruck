class Api::V1::ProductInventoriesController < Api::V1::ApiController
  include Api::V1::MerchantAuthenticatable
  include InventoryManager
  before_action :authenticate_merchant!

  # GET /api/v1/trucks/:truck_id/inventory
  def index
    @product_inventories = InventoryManager.from_truck_id(params[:truck_id]).list.includes(:product)
    render_template 'index', product_inventories: @product_inventories
  end

  # PUT /api/v1/trucks/:truck_id/inventory
  def update
    @product_inventory = ProductInventory.create_or_update(inventory_params)
    render_template 'response', message: 'Inventory was successfully updated', product_inventory: @product_inventory
  end

  # DELETE /api/v1/trucks/:truck_id/inventory
  def destroy
    InventoryManager.from_truck_id(params[:truck_id]).destroy(params[:product_id])
    render json: { message: 'Inventory record was successfully deleted' }, status: :ok
  end

  protected

  def inventory_params
    params.permit(:truck_id, :product_id, :quantity)
  end
end
