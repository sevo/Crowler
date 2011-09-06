class CreateXmlFileDownloads < ActiveRecord::Migration
  def self.up
    create_table :xml_file_downloads do |t|
      t.text :url
      t.text :path
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :xml_file_downloads
  end
end
