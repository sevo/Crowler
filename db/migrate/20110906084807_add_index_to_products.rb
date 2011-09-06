class AddIndexToProducts < ActiveRecord::Migration
  def self.up
    add_index :products, :name, :length => 500
    add_index :products, :url, :length => 500
  end

  def self.down
    remove_index :products, :name
    remove_index :products, :url
  end
end
