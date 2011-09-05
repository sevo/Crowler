class AddAttributesToShopOffer < ActiveRecord::Migration
  def self.up
    add_column :shop_offers, :availability, :string
    add_column :shop_offers, :shipping, :float
  end

  def self.down
    remove_column :shop_offers, :shipping
    remove_column :shop_offers, :availability
  end
end
