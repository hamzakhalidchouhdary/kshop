class Business < ApplicationRecord
  belongs_to :organization
  has_many :staffs
  has_many :products
end
