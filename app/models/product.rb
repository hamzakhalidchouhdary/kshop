class Product < ApplicationRecord
  belongs_to :business
  has_many :order_items
  has_many :orders, :through => :order_items
  has_many :returned_items
  has_many :return, through: :returned_items

end
