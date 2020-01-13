class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :unit_price
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
