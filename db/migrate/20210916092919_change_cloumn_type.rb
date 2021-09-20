class ChangeCloumnType < ActiveRecord::Migration[6.1]
  def up
    change_table :organizations do |t|
      t.change :package_price, :float
    end
    change_table :packages do |t|
      t.change :price, :float, using: 'price::double precision'
    end
  end
  
  def down
    change_table :organizations do |t|
      t.change :package_price, :integer
    end
    change_table :packages do |t|
      t.change :price, :integer
    end
  end
end
