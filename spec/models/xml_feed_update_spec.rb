# encoding: UTF-8

require 'spec_helper'

describe XmlFeedHandler do
    before :each do
      @shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})
    end

    def valid_attributes
      {
          :shop => @shop,
          :feed_url => "#{RAILS_ROOT}/spec/tmp/feed.xml"
      }
    end
  
  describe "creating new feed handler" do
    it "should be valid" do
      handler = XmlFeedHandler.create(valid_attributes)
      handler.valid?.should == true
    end

    it "should enqueue after create" do
      handler = XmlFeedHandler.create(valid_attributes)
      handler.status.should == "enqueued"
    end

    it "should run after perform called" do
      handler = XmlFeedHandler.create(valid_attributes)
      handler.perform
      handler.status.should == "running"
      handler.result.should == "alza.sk -4712-01-01 00:00:00 UTC\n Total number of products: 4\n0 of products skipped (without required attributes)"
    end

    it "should create products in database" do
      handler = XmlFeedHandler.create(valid_attributes)
      handler.perform
      products = Product.find(:all)
      products.count.should == 4
      products.map {|p| p.name}.should include "Adobe CS5 Design STD WIN CZ GOV License 1300"
      products.map {|p| p.name}.should include "IBM 500GB 3.5in HS 7.2K SATA HDD 41Y8226"
      products.map {|p| p.name}.should include "IntelÂ® Main IO Fan Module"
      products.map {|p| p.name}.should include "IntelÂ® Main System Fan Module"
    end
  end
end
