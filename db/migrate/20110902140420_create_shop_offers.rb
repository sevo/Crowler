class CreateShopOffers < ActiveRecord::Migration
  def self.up
    create_table :shop_offers do |t|
      t.integer :shop_id
      t.integer :product_id
      t.float :cost
      t.text :name

      t.timestamps
    end
  end

  def self.down
    drop_table :shop_offers
  end
end
