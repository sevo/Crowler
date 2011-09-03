# encoding: UTF-8

namespace :crawler do
  desc "Get categories hierarchy"
  task :get_categories => :environment do
    require File.join(File.dirname(__FILE__), "categories_parser.rb")
    CategoriesParser::all_categories
  end

  desc "Get products"
  task :get_products => :environment do
    require File.join(File.dirname(__FILE__), "products_parser.rb")
    ProductParser::all_products
  end

  #desc "Get total number of products"
  #task :get_product_number => :environment do
  #  require File.join(File.dirname(__FILE__), "products_parser.rb")
  #  ProductParser::products_number
  #end

  #desc "process one product page"
  #task :process_page => :environment do
  #  require File.join(File.dirname(__FILE__), "products_parser.rb")
  #  require 'mechanize'
  #  agent = Mechanize.new
  #  url = "http://www.pricemania.sk/katalog/digitalne-fotoaparaty-kompaktne/"
  #  agent.get(url+"?catalog_numitems=200")
  #
  #  ProductParser::process_product(url,agent,1)
  #end

  desc "retrieve shop list"
  task :get_shops => :environment do
    require File.join(File.dirname(__FILE__), "shops_parser.rb")
    ShopsParser::all_shops
  end

  desc "retrieve shop offers"
  task :get_offers => :environment do
    require File.join(File.dirname(__FILE__), "offer_parser.rb")
    OfferParser::all_offers
  end

end