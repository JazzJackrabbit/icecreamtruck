class Api::V1::ProductInventoriesController < Api::V1::ApiController
  
  # GET /api/v1/trucks/:id/inventory
  def index
    @product_inventories = ProductInventory::InventoryManager.from_truck_id(params[:truck_id]).list
    render_template 'index', product_inventories: @product_inventories
  end

  # PUT /api/v1/trucks/:id/inventory
  def update
    @product_inventory = ProductInventory.create_or_update(inventory_params)
    render_template 'response', message: 'Inventory was successfully updated', product_inventory: @product_inventory
  end

  protected

  def inventory_params
    params.permit(:truck_id, :product_id, :quantity)
  end
end
