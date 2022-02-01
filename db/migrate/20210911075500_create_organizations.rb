class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.references :package
      t.string :owned_by
      t.string :name
      t.string :address
      t.string :phone_no
      t.string :email
      t.integer :package_price
      t.string :status


      t.timestamps
    end
  end
end
