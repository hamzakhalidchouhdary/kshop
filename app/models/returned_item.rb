class ReturnedItem < ApplicationRecord
  belongs_to :product
  belongs_to :return
end
