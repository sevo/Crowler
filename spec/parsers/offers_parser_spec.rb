# encoding: UTF-8

require 'spec_helper'
require "#{RAILS_ROOT}/lib/offers_parser"

describe OffersParser do
  it "should extract all product offers" do
    category = Category.create({:name => "Autorádia",:url => "http://www.pricemania.sk/katalog/autoradia-s-cd-mp3/"})
    product = Product.create({:name => "Irandom CS-103", :url => "http://www.pricemania.sk/katalog/autoradia-s-cd-mp3/irandom-cs-103-2263263/", :category => category})
    shop1 = Shop.create({:name => "pixmania.sk", :url => "http://affiliation.fotovista.com/track/click.php?bid=MTQ4Ozg3ODM&desturl=http%3A%2F%2Fwww.pixmania.sk%2Fsk%2Fsk%2Fhome.html"})
    shop2 = Shop.create({:name => "talkive.sk", :url => "www.talkive.sk"})

    OffersParser::product_detail(product)
    
    offers = ShopOffer.find(:all)
    offers.count.should == 2

    offer = ShopOffer.find_by_shop_id_and_product_id(shop1.id,product.id)
    offer.name.should == "Autorádio USB/SD CS-103"
  end

end