class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.references :organization
      t.references :business
      t.references :role
      t.string :name
      t.string :phone_no
      t.string :address
      t.float :salary
      t.boolean :salary_paid

      t.timestamps
    end
  end
end
