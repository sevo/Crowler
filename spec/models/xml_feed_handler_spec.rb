# encoding: UTF-8

require 'spec_helper'

describe XmlFeedHandler do
    before :each do
      @shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})
    end

    def valid_attributes
      {
          :shop => @shop,
          :feed_path => "#{RAILS_ROOT}/spec/tmp/feed.xml"
      }
    end

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
      handler.status.should == "finished"
      handler.result.should == "alza.sk -4712-01-01 00:00:00 UTC\n Total number of products: 4\n0 of products skipped (without required attributes)"
    end
end
