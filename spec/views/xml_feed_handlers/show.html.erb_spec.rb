# encoding: UTF-8

require 'spec_helper'

describe "xml_feed_handlers/show.html.erb" do

  it "renders attributes in <p>" do
    shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})

    @xml_feed_handler = assign(:xml_feed_handler, stub_model(XmlFeedHandler,
      :feed_url => "MyText",
      :shop => shop,
      :status => "Status",
      :result => "MyText"
    ))
    @results = []

    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end

  it "should show import results" do
    shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})
    @xml_feed_handler = XmlFeedHandler.create(:shop => shop, :feed_path => "#{RAILS_ROOT}/spec/tmp/feed.xml")
    @xml_feed_handler.perform

    @results = XmlImportResult.find(:all)
    shop_offer_names = @results.map{|r| r.shop_offer.name}
    shop_offer_names.should == ["Adobe CS5 Design STD WIN CZ GOV License 1300",
                                "IBM 500GB 3.5in HS 7.2K SATA HDD 41Y8226",
                                "IntelÂ® Main IO Fan Module",
                                "IntelÂ® Main System Fan Module"]

    render
    rendered.should match(@results.first.shop_offer.name)
    rendered.should match(@results.first.status)
    rendered.should match(@results.first.product.name)
  end

end
