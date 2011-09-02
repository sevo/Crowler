class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.text :name
      t.text :url
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
