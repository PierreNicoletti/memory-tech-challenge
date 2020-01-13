class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.date :date
      t.references :customer, null: false, foreign_key: true
      t.string :external_id

      t.timestamps
    end
  end
end
