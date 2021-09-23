class CreateOrganizationPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :organization_payments do |t|
      t.references :organization
      t.float :payable
      t.boolean :is_paid

      t.timestamps
    end
  end
end
