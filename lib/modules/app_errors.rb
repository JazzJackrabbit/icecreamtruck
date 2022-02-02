module AppErrors
  class AppError < StandardError
    def initialize(msg = nil, object: nil, options: {})
      super(msg)
      @object = object 
      @options = options
    end 
  end

  module API
    class RouteNotFoundError < AppError; end
  end

  module OrderErrors
    class FailedOrderError < AppError; end
  end

  module InventoryErrors
    class ProductInventoryNotFoundError < AppError; end
    class TruckNotFoundError < AppError; end
  end
end