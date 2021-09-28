class CreateOfferTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :offer_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
