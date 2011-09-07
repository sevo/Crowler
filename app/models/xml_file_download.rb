class XmlFileDownload < ActiveRecord::Base

  belongs_to :shop
  belongs_to :xml_feed_handler

  before_destroy :delete
  after_create :run

  def download
    require 'open-uri'

      time = Time.new
      self.path = "#{Rails.root.to_s}/tmp/#{time.year}/#{time.month.to_s}/#{time.day.to_s}/#{time.to_i.to_s}.xml"
      save
      dirname = File.dirname(self.path)
      make_subdirs dirname unless Dir.exist? dirname
      writeOut = open(self.path, "wb")
      writeOut.write(open(self.url).read)
      writeOut.close

  end

  def delete
    begin
      File.delete self.path
    rescue
    end
  end

  def run
    self.status="enqueued"
    save
    Delayed::Job.enqueue self
  end

  def perform
    self.status = "running"
    save
    download
    self.status = "finished"
    save
    feed_handler = XmlFeedHandler.create(:feed_path => self.path, :shop => self.shop)
    feed_handler.xml_file_download_id = self.id
    feed_handler.save
  end

  def error(job, exception)
    self.status = "error"
    self.result ||= ""
    self.result += " "+exception.to_s
    save
  end

  private
  def make_subdirs path
    subdirs = path.split('/')
    actual = "/"
    subdirs.each do |s|
      actual=actual+"/"+s
      Dir.mkdir actual unless Dir.exist? actual
    end
  end
end
