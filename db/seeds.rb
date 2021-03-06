# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).



#  ========= INITIALIZE TRUCK ============

truck = Truck.create(name: 'The Scoop Bus')
p "Created a truck (id: #{truck.id})"



#  ========= INITIALIZE ICE CREAM PRODUCTS ============

category = ProductCategory.create(name: 'Ice Cream')
p "Created #{category.name} category"

ice_cream_flavors = ['Chocolate', 'Pistachio', 'Strawberry', 'Mint']
ice_cream_flavors.each do |flavor|
  product = Product.create(category: category, name: "#{flavor} Ice Cream", price: rand(1.00..10.00), labels: [flavor.downcase])
  p "Created '#{product.name}' product"
  quantity = 200
  truck.inventory.add(product.id, quantity)
  p "Added #{quantity} units of #{product.name} to Truck##{truck.id} inventory"
end



#  ========= INITIALIZE SHAVED ICE PRODUCTS ============ 

category = ProductCategory.create(name: 'Shaved Ice')
p "Created #{category.name} category"
product = Product.create(category: category, name: "Kakigori Shaved Ice", price: rand(1.00..10.00))
p "Created '#{product.name}' product"
quantity = 80
truck.inventory.add(product.id, quantity)
p "Added #{quantity} units of #{product.name} to Truck##{truck.id} inventory"



#  ========= INITIALIZE SNACK PRODUCTS ============

category = ProductCategory.create(name: 'Snack')
p "Created #{category.name} category"

product = Product.create(category: category, name: "Caramel Bar", price: rand(1.00..10.00))
p "Created '#{product.name}' product"
quantity = 50
truck.inventory.add(product.id, quantity)
p "Added #{quantity} units of #{product.name} to Truck##{truck.id} inventory"




#  ========= INITIALIZE MERCHANT ============

merchant = Merchant.create(email: 'merchant@icecreamtruck.xyz', password: '12345678', password_confirmation: '12345678')
p "Created merchant account (#{merchant.email} / #{merchant.password})"



#  ========= INITIALIZE ORDERS ============

5.times do 
  product = truck.products.sample
  quantity = rand(1..5)
  order = Order.create(truck: truck, items_attributes: [{
    product_id: product.id,
    quantity: quantity
  }])
  p "Created Order##{order.id} for truck (#{quantity} units of #{product.name} for $#{order.total_amount}"
end
