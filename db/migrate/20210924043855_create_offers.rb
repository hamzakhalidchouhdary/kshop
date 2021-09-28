class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.references :business
      t.references :offer_type
      t.string :name
      t.float :discount
      t.float :min_amount
      t.datetime :end_on

      t.timestamps
    end
  end
end
