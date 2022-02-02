module TruckInventoryManagement
  extend ActiveSupport::Concern
  include AppErrors::InventoryErrors
  
  class InventoryManager
    def initialize(truck)
      @truck = truck
    end

    def self.from_truck_id(truck_id)
      truck = Truck.find(truck_id)
      raise AppErrors::InventoryErrors::TruckNotFoundError unless truck.present?
      self.new(truck)
    end

    def list
      @truck.inventories
    end

    def products
      Product.stocked_in_truck(@truck.id)
    end

    def find(product_id)
      @truck.inventories.where(product_id: product_id).first
    end

    def add(product_id, quantity)
      inventory = @truck.inventories.where(product_id: product_id).first ||
                  @truck.inventories.new(product_id: product_id, quantity: 0)
      abs_quantity = quantity.to_i.abs
      inventory.quantity += abs_quantity
      inventory.save!
      inventory
    end

    def remove(product_id, quantity)
      inventory = @truck.inventories.where(product_id: product_id).first 
      raise AppErrors::InventoryErrors::ProductInventoryNotFoundError unless inventory.present?
      abs_quantity = quantity.to_i.abs
      inventory.quantity -= abs_quantity
      inventory.save!
    end

    def destroy(product_id)
      inventory = @truck.inventories.where(product_id: product_id).first 
      raise AppErrors::InventoryErrors::ProductInventoryNotFoundError unless inventory.present?
      inventory.destroy
    end

    def set(product_id, quantity)
      inventory = @truck.inventories.where(product_id: product_id.to_i).first || 
                  @truck.inventories.new(product_id: product_id.to_i)
      inventory.quantity = quantity.to_i
      inventory.save!
      inventory
    end
  end
end