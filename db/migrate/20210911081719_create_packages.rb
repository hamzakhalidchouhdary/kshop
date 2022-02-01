class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :price
      t.string :type 
      
      t.timestamps
    end
  end
end
