class CreateReturnedItems < ActiveRecord::Migration[6.1]
  def change
    create_table :returned_items do |t|
      t.references :product
      t.references :return
      t.integer :quantity
      t.float :price

      t.timestamps
    end
  end
end
