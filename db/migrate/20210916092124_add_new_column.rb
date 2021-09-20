class AddNewColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :shop_limit, :integer
    add_column :packages, :shop_limit, :integer
  end
end
