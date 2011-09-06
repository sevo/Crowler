class AddIndexToShops < ActiveRecord::Migration
  def self.up
    add_index :shops, :url, :length => 500
    add_index :shops, :name, :length => 500
  end

  def self.down
    remove_index :shops, :url
    remove_index :shops, :name
  end
end
