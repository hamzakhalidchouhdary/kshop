class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.references :business
      t.string :name
      t.integer :stock_available
      t.integer :out_of_stock_limit
      t.float :cost_price
      t.float :sell_price

      t.timestamps
    end
  end
end
