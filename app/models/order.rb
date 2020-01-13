class Order < ApplicationRecord
  belongs_to :customer
  validates :date, presence: true
  validates :external_id, presence: true
  validates :external_id, uniqueness: true
end
