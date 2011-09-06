class AddIndexToProductDescription < ActiveRecord::Migration
  def self.up
    add_index :product_descriptions, :product_id
    add_index :product_descriptions, :shop_id
  end

  def self.down
    remove_index :product_descriptions, :product_id
    remove_index :product_descriptions, :shop_id
  end
end
