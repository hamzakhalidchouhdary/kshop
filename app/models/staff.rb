class Staff < ApplicationRecord
  belongs_to :organization
  belongs_to :business
  belongs_to :role

  has_one :users
  has_many :staff_payments
end
