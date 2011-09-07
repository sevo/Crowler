class AddXmlFileDownloadIdToXmlFeedHandler < ActiveRecord::Migration
  def self.up
    add_column :xml_feed_handlers, :xml_file_download_id, :integer
  end

  def self.down
    remove_column :xml_feed_handlers, :xml_file_download_id
  end
end
