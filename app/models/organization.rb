class Organization < ApplicationRecord
  belongs_to :package

  has_many :users
  has_many :businesses
  has_many :staffs
  has_many :organization_payments
end
