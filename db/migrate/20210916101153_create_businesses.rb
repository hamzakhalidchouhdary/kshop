class CreateBusinesses < ActiveRecord::Migration[6.1]
  def change
    create_table :businesses do |t|
      t.references :organization
      t.references :business_category
      t.string :name
      t.string :address
      t.string :phone_no
      t.string :email

      t.timestamps
    end
  end
end
