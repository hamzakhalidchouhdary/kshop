class CreateReturns < ActiveRecord::Migration[6.1]
  def change
    create_table :returns do |t|
      t.references :order
      t.float :total_amount
      t.float :paid_amount

      t.timestamps
    end
  end
end
