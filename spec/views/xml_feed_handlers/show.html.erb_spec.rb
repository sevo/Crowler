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
    product = Product.create(:name => "Westige Moto black")
    offer = ShopOffer.create(:name => "Westige Moto black", :shop => shop, :product => product)
    product = Product.create(:name => "Sencor SCD 7405BMR")
    offer = ShopOffer.create(:name => "Sencor SCD 7405BMR", :shop => shop, :product => product)
    product = Product.create(:name => "Autec Race 5 7x17 5x108 ET45")
    offer = ShopOffer.create(:name => "Autec Race 5 7x17 5x108 ET45", :shop => shop, :product => product)
    product = Product.create(:name => "Autec")
    offer = ShopOffer.create(:name => "Autec", :shop => shop, :product => product)
    @xml_feed_handler = XmlFeedHandler.create(:shop => shop, :feed_path => "#{RAILS_ROOT}/spec/tmp/feed.xml")
    @xml_feed_handler.perform

    @results = XmlImportResult.find(:all)
    shop_offer_names = @results.map{|r| r.shop_offer.name}
    shop_offer_names.should == ["Westige Moto black",
                                "Sencor SCD 7405BMR",
                                "Autec Race 5 7x17 5x108 ET45",
                                "Autec"]

    products = Product.find(:all)
    @select_array = []
    products.each do |p|
      @select_array << [p.name, p.id] if p.name.length < 30
      @select_array << [p.name[0..30]+" ...", p.id] unless p.name.length < 30
    end

    #render :action => :show, :url => {:id => @xml_feed_handler.id}
    #rendered.should match(@results.first.shop_offer.name)
    #rendered.should match(@results.first.status)
    #rendered.should match(@results.first.product.name)

    render
    #get :show, :id => @xml_feed_handler.id
    #response.should match(@results.first.shop_offer.name)
  end

end
