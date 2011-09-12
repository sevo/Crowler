require 'spec_helper'

describe XmlImportResult do

  before :each do
    dirname = "#{Rails.root}/tmp/simstring/"

    Dir.entries(dirname).each do |f|
      File.delete(dirname+f) if f.start_with?("products")
    end

    system("cp #{Rails.root}/spec/tmp/products.db* #{Rails.root}/tmp/simstring/")

    @shop1 = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})
    @shop2 = Shop.create({:name => "nay.sk", :url => "http://www.nay.sk"})
    @product1 = Product.create(:name => "uzasna kosacka stvorkolesova")
    @product2 = Product.create(:name => "stolny futbal velky 3mx2m")
    @offer = ShopOffer.create(:product => @product1, :shop => @shop1, :name => "uzasna kosacka stvorkolesova")
  end

  #after :all do
  #  dirname = "#{Rails.root}/tmp/simstring/"
  #
  #  Dir.entries(dirname).each do |f|
  #    File.delete(dirname+f) if f.start_with?("products")
  #  end
  #end


  it "should create import result when match method is executed" do
    result = XmlImportResult.match("meno produktu",@shop1.id)
    result.class.should be XmlImportResult
  end

  it "should create import result offer exist" do
    result = XmlImportResult.match("uzasna kosacka stvorkolesova",@shop1.id)
    result.status.should == "linked"
    result.product.should == @product1
    result.shop_offer.should == @offer
  end


  it "should create import result product matches" do
    result = XmlImportResult.match("uzasna kosacka stvorkolesova",@shop2.id)
    result.status.should == "matched"
    result.most_common.should == @product1
    result.shop_offer.should_not == @offer
    ShopOffer.find(:all).size.should == 2
  end


  it "should create import result when no product matched" do
    result = XmlImportResult.match("uzasna",@shop2.id)
    result.status.should == "unknown"
    result.shop_offer.should_not == @offer
    ShopOffer.find(:all).size.should == 2
  end
end
