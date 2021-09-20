class User < ApplicationRecord
  has_secure_password

  belongs_to :role
  belongs_to :organization
  belongs_to :staff
end
