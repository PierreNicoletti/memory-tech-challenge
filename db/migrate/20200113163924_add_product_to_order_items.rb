class AddProductToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :unit_price, :float
    add_column :order_items, :product_code, :string
    add_column :order_items, :product_description, :string
  end
end
