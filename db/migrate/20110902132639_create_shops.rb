class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.text :name
      t.text :url

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
