class MoveSomeAttributesFromProductToShopOffer < ActiveRecord::Migration
  def self.up
    add_column :shop_offers, :manufacturer, :string
    remove_column :products, :manufacturer
    add_column :shop_offers, :part_number, :string
    remove_column :products, :part_number
    add_column :shop_offers, :ean, :string
    remove_column :products, :ean
  end

  def self.down
    remove_column :shop_offers, :manufacturer
    add_column :products, :manufacturer, :string
    remove_column :shop_offers, :part_number
    add_column :products, :part_number, :string
    remove_column :shop_offers, :ean
    add_column :products, :ean, :string
  end
end
