class AddProductIdToShopOffer < ActiveRecord::Migration
  def self.up
    add_column :shop_offers, :product_id, :integer
  end

  def self.down
    remove_column :shop_offers, :product_id
  end
end
