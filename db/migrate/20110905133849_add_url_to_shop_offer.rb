class AddUrlToShopOffer < ActiveRecord::Migration
  def self.up
    add_column :shop_offers, :url, :text
  end

  def self.down
    remove_column :shop_offers, :url
  end
end
