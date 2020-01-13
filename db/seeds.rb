# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

puts "Destroying all order items"

OrderItem.delete_all

puts "Destroying all orders"

Order.delete_all

puts "Destroying all customers"

Customer.delete_all

puts "Parsing CSV file..."

filepath = 'db/memory-tech-challenge-data.csv'
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }

customer_ids = []
order_ids = []
customers = []
orders = []
order_items = []

CSV.foreach(filepath, csv_options) do |row|
  unless customer_ids.include?(row['customer_id'])
    customers << Customer.new({ external_id: row['customer_id'], country: row['country'] })
    customer_ids << row['customer_id']
  end

  unless order_ids.include?(row['order_id'])
    orders << Order.new({ date: row['date'].to_date, external_id: row['order_id'], customer: customers.last})
    order_ids << row['order_id']
  end

  order_items << OrderItem.new({ quantity: row['quantity'].to_i, product_code: row['product_code'], product_description: row['product_description'], unit_price: row['unit_price'].to_f, order: orders.last})

end

puts "Importing customers to DB..."

Customer.import(customers)

puts "Importing orders to DB..."

Order.import(orders)

puts "Importing order items to DB..."

OrderItem.import(order_items)


