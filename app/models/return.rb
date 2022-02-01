class Return < ApplicationRecord
  belongs_to :order
  has_many :returned_items
  has_many :products, through: :returned_items
end
