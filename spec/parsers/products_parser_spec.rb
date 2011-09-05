# encoding: UTF-8

require 'spec_helper'
require "#{RAILS_ROOT}/lib/products_parser"
require 'mechanize'
require 'nokogiri'
require 'open-uri'

describe ProductParser do

  it "should create product from category page" do
    url = "http://www.pricemania.sk/katalog/autoradia-s-cd-mp3/"
    doc = Nokogiri::HTML(open(url))
    product_name = doc.css("h2 a").first.text
    product_url = PRICEMANIA_URL + doc.css("h2 a").first[:href]

    agent = Mechanize.new
    agent.get(url+"?catalog_numitems=200")
    category = Category.create({:name => "Autorádia", :url => url})
    ProductParser::process_product(category,agent,1)

    product = Product.find_by_url(product_url)
    product.name.should == product_name
  end

  it "should process 200 products at once" do
    url = "http://www.pricemania.sk/katalog/autoradia-s-cd-mp3/"
    doc = Nokogiri::HTML(open(url))
    result_number = doc.at_css(".filter-button")[:value][/[0-9]+/].to_i

    agent = Mechanize.new
    agent.get(url+"?catalog_numitems=200")
    category = Category.create({:name => "Autorádia", :url => url})
    pages,products = ProductParser::process_product(category,agent,1)
    pages.should == result_number / 200 +1
    products.should == result_number
  end

end