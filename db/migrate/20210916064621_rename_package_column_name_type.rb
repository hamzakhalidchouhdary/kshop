class RenamePackageColumnNameType < ActiveRecord::Migration[6.1]
  def change
    rename_column :packages, :type, :price_type
  end
end
