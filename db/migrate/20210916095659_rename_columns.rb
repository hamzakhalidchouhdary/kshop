class RenameColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :packages, :shop_limit, :business_limit
    rename_column :organizations, :shop_limit, :business_limit
  end
end
