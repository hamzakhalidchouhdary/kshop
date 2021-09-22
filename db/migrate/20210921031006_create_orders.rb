class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :business
      t.integer :total_products
      t.float :total_amount
      t.float :discount_amount
      t.float :paid_amount
      t.string :customer_name
      t.string :delivery_address
      t.string :billing_address
      t.string :contact_no

      t.timestamps
    end
  end
end
