namespace :data do
  desc "Adds sample records to the database"
  task seed_sample: :environment do

    truck = Truck.create(name: 'The Scoop Bus')
    p "Created a truck (id: #{truck.id})"

    #  ========= INITIALIZE ICE CREAM PRODUCTS ============

    category = ProductCategory.create(name: 'Ice Cream')
    p "Created #{category.name} category"

    ice_cream_flavors = ['Chocolate', 'Pistachio', 'Strawberry', 'Mint']
    ice_cream_flavors.each do |flavor|
      product = Product.create(category: category, name: "#{flavor} Ice Cream", price: rand(1.00..10.00))
      p "Created '#{product.name}' product"
      quantity = 100
      truck.inventory.add(product.id, quantity)
      p "Added #{quantity} units of #{product.name} to Truck##{truck.id} inventory"
    end

    #  ========= INITIALIZE SHAVED ICE PRODUCTS ============ 

    category = ProductCategory.create(name: 'Shaved Ice')
    p "Created #{category.name} category"
    product = Product.create(category: category, name: "Kakigori Shaved Ice", price: rand(1.00..10.00))
    p "Created '#{product.name}' product"
    quantity = 100
    truck.inventory.add(product.id, quantity)
    p "Added #{quantity} units of #{product.name} to Truck##{truck.id} inventory"


    #  ========= INITIALIZE SNACK PRODUCTS ============

    category = ProductCategory.create(name: 'Snack')
    p "Created #{category.name} category"

    product = Product.create(category: category, name: "Caramel Bar", price: rand(1.00..10.00))
    p "Created '#{product.name}' product"
    quantity = 100
    truck.inventory.add(product.id, quantity)
    p "Added #{quantity} units of #{product.name} to Truck##{truck.id} inventory"
  end
end