class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :product
      t.references :order
      t.integer :quantity
      t.float :price 
      
      t.timestamps

      t.index [:product_id, :order_id], unique: true

    end
  end
end
