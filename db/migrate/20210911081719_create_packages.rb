class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.float :price
      t.string :price_type 
      t.integer :business_limit

      t.timestamps
    end
  end
end
