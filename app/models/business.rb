class Business < ApplicationRecord
  belongs_to :organization
  belongs_to :business_category

  has_many :staffs
  has_many :products
  has_many :orders
  has_many :offers
end
