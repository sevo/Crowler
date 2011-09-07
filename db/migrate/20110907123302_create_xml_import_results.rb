class CreateXmlImportResults < ActiveRecord::Migration
  def self.up
    create_table :xml_import_results do |t|
      t.integer :xml_feed_handler_id
      t.integer :shop_offer_id
      t.integer :product_id
      t.integer :most_common_id
      t.float :match
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :xml_import_results
  end
end
