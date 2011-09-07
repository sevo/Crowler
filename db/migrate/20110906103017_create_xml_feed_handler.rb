class CreateXmlFeedHandler < ActiveRecord::Migration
  def self.up
    create_table :xml_feed_handlers do |t|
      t.text :feed_path
      t.string :status
      t.text :result
      t.integer :shop_id

      t.timestamps
    end
  end

  def self.down
    drop_table :xml_feed_handlers
  end
end
