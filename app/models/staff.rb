class Staff < ApplicationRecord
  belongs_to :organization
  belongs_to :business
  belongs_to :role
  has_many :users
end
