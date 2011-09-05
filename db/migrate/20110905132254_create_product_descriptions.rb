class CreateProductDescriptions < ActiveRecord::Migration
  def self.up
    create_table :product_descriptions do |t|
      t.text :description
      t.integer :shop_id
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_descriptions
  end
end
