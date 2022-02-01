class Order < ApplicationRecord
  belongs_to :business
  has_many :order_items
  has_many :products, :through => :order_items
  has_many :returns
end
