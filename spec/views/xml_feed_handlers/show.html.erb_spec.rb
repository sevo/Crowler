# encoding: UTF-8

require 'spec_helper'
require "capybara/rails"

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

    visit '/xml_feed_handlers'
    click_link "Show"
    assert page.has_content?("Westige Moto black")
    find(:xpath, "//table/tr[2]").should have_button("Link")
    find(:xpath, "//table/tr[2]").should have_content("Westige Moto black")
    find(:xpath, "//table/tr[2]").should have_content("linked")
    #save_and_open_page
  end

  it "should show import results" do
    #shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})
    #product = Product.create(:name => "Sencor SCD 7405BMR")
    #offer = ShopOffer.create(:name => "Sencor SCD 7405BMR", :shop => shop, :product => product)
    #product = Product.create(:name => "Autec Race 5 7x17 5x108 ET45")
    #offer = ShopOffer.create(:name => "Autec Race 5 7x17 5x108 ET45", :shop => shop, :product => product)

    shop = Factory(:shop, :name => "alza.sk")
    product = Factory(:product, :name => "Sencor SCD 7405BMR")
    offer = Factory(:shop_offer, :name => "Sencor SCD 7405BMR", :shop => shop, :product => product)
    product = Factory(:product, :name => "Autec Race 5 7x17 5x108 ET45")
    offer = Factory(:shop_offer, :name => "Autec Race 5 7x17 5x108 ET45", :shop => shop, :product => product)

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

    visit '/xml_feed_handlers'
    click_link "Show"
    find(:xpath, "//table/tr[2]").should have_button("Link")
    find(:xpath, "//table/tr[2]").should have_content("Westige Moto black")
    find(:xpath, "//table/tr[2]").should have_content("unknown")

    find(:xpath, "//table/tr[3]").should have_button("Link")
    find(:xpath, "//table/tr[3]").should have_content("Sencor SCD 7405BMR")
    find(:xpath, "//table/tr[3]").should have_content("linked")

    find(:xpath, "//table/tr[4]").should have_button("Link")
    find(:xpath, "//table/tr[4]").should have_content("Autec Race 5 7x17 5x108 ET45")
    find(:xpath, "//table/tr[4]").should have_content("linked")

    find(:xpath, "//table/tr[5]").should have_button("Link")
    find(:xpath, "//table/tr[5]").should have_content("Autec")
    find(:xpath, "//table/tr[5]").should have_content("unknown")

    #save_and_open_page
  end

end
