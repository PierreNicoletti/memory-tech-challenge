class Product < ApplicationRecord
  validates :code, presence: true
  validates :unit_price, presence: true
  validates :code, uniqueness: true
end
