class XmlFeedHandler < ActiveRecord::Base
  belongs_to :shop
  
  validates_presence_of :shop_id
  after_create :run

  def was_started?
    !self.status.nil?
  end

  def run
    self.status="enqueued"
    save
    Delayed::Job.enqueue self
  end

  def perform
    require "#{RAILS_ROOT}/lib/xml_feed_parser.rb"
    self.status = "running"
    save
    XmlFeedParser::parse(open(feed_url),shop,self)
  end

  def after(job)
    self.status = "finished"
    save
  end

  def error(job, exception)
    self.status = "error"
    self.result ||= ""
    self.result += " "+exception.to_s
    save
  end
end

