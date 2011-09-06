class AddIndexToShopOffer < ActiveRecord::Migration
  def self.up
    add_index :shop_offers, :product_id
    add_index :shop_offers, :shop_id
  end

  def self.down
    remove_index :shop_offers, :product_id
    remove_index :shop_offers, :shop_id
  end
end
