class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  validates :date, presence: true
  validates :external_id, presence: true
  validates :external_id, uniqueness: true


  def total_amount
    total_amount = 0
    # order_items.each do |order_item|
    #   total_amount += order_item.quantity * order_item.product.unit_price.to_f
    # end
    return total_amount
  end

end
