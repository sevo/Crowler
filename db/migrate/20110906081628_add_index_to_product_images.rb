class AddIndexToProductImages < ActiveRecord::Migration
  def self.up
    add_index :product_images, :product_id
    add_index :product_images, :url, :length => 500
  end

  def self.down
    remove_index :product_images, :product_id
    remove_index :product_images, :url
  end
end
