class Customer < ApplicationRecord
  validates :country, presence: true
  validates :external_id, presence: true
  validates :external_id, uniqueness: true
  has_many :orders
end
