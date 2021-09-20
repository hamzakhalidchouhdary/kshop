class Organization < ApplicationRecord
  has_many :users
  belongs_to :package
  has_many :businesses
  has_many :staffs
end
