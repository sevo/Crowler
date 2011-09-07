# encoding: UTF-8

require 'spec_helper'

describe XmlFileDownload do
  before :each do
      @shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})
    end

    def valid_attributes
      {
          :shop => @shop,
          :url => "http://c.sme.sk/imgs/pager/logo.gif"
      }
    end

  it "should be valid" do
      download = XmlFileDownload.create(valid_attributes)
      download.valid?.should == true
    end

    it "should enqueue after create" do
      download = XmlFileDownload.create(valid_attributes)
      download.status.should == "enqueued"
    end

    it "should run after perform called" do
      download = XmlFileDownload.create(valid_attributes)
      download.perform
      download.status.should == "finished"
    end

    it "should download file" do
      download = XmlFileDownload.create(valid_attributes)
      download.perform
      File.exist?(download.path).should be true
    end

    it "should run feed processing after file is downloaded" do
      download = XmlFileDownload.create(valid_attributes)
      download.perform
      download.status.should == "finished"
      XmlFeedHandler.find(:all).size.should be 1
    end

    it "should create file in subdirectories" do
      time= Time.new
      download = XmlFileDownload.create(valid_attributes)
      download.perform
      
      dirname = "#{Rails.root.to_s}/tmp/#{time.year}/#{time.month.to_s}/#{time.day.to_s}"

      File.dirname(download.path).should == dirname
    end

end
