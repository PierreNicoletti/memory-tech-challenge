class OrderItem < ApplicationRecord
  belongs_to :order
  validates :quantity, presence: true
end
