# encoding: UTF-8

namespace :crawler do
  desc "Get categories hierarchy"
  task :get_categories => :environment do
    require File.join(File.dirname(__FILE__), "../categories_parser.rb")
    CategoriesParser::all_categories
  end

  desc "Get products"
  task :get_products => :environment do
    require File.join(File.dirname(__FILE__), "../products_parser.rb")
    ProductParser::all_products
  end

  desc "retrieve shop list"
  task :get_shops => :environment do
    require File.join(File.dirname(__FILE__), "../shops_parser.rb")
    ShopsParser::all_shops
  end

  desc "retrieve shop offers"
  task :get_offers => :environment do
    require File.join(File.dirname(__FILE__), "../offers_parser.rb")
    OffersParser::all_product_offers
  end


end