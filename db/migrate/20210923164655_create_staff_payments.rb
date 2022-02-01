class CreateStaffPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_payments do |t|
      t.references :staff
      t.float :payable
      t.boolean :is_paid

      t.timestamps
    end
  end
end
