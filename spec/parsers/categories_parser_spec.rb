# encoding: UTF-8

require 'spec_helper'
require "#{RAILS_ROOT}/lib/categories_parser"

describe CategoriesParser do
  it "should extract categories from home page" do
    category_list = CategoriesParser::process_home_page_for_category_pages

    category_list.size.should == 21
    category_list.should include(Category.find_by_name("Auto moto"))
    category_list.should include(Category.find_by_name("Chovateľské potreby"))
    category_list.should include(Category.find_by_name("Mix"))
    category_list.should include(Category.find_by_name("Knihy"))
    category_list.should include(Category.find_by_name("Počítače a kancelária"))

    Category.find_by_name("Auto moto").url.should == "http://www.pricemania.sk/katalog/auto-moto/"
  end

  it "should process one page for categories" do
    category_list = CategoriesParser::process_home_page_for_category_pages
    category = Category.find_by_name("Auto moto")
    category_list = CategoriesParser::process_category_page(category)

    category_list.size.should == 19 #18 podkategorii + 1 nadradena podkategoria
    category_list.should include(Category.find_by_name("home"))
    category_list.should include(Category.find_by_name("Zimné pneumatiky"))
    category_list.should include(Category.find_by_name("Auto HiFi"))
    category_list.should include(Category.find_by_name("Motocykle"))
    category_list.should include(Category.find_by_name("Oleje"))
    
    Category.find_by_name("Zimné pneumatiky").url.should == "http://www.pricemania.sk/katalog/zimne-pneumatiky/"
  end

  it "should extract no subcategories from leaf category page" do
    parent_category = Category.create({:name => "Auto HiFi", :url => "http://www.pricemania.sk/katalog/auto-hifi/", })
    category = Category.create({:name => "Autorádia", :url => "http://www.pricemania.sk/katalog/autoradia-s-cd-mp3/"})
    category.parent = parent_category

    category_list = CategoriesParser::process_category_page(category)

    category_list.size.should == 1
    category_list.should include parent_category
  end

  it "should set home page as parent category for first level categories" do
    category_list = CategoriesParser::process_home_page_for_category_pages
    home = Category.find_by_name("home")
    first_level_category = category_list.first

    first_level_category.parent.should == home
  end

  it "should set parent category for category page" do
    parent_category = Category.create({:name => "Auto moto", :url => "http://www.pricemania.sk/katalog/auto-moto/", })
    category = Category.create({:name => "Auto HiFi", :url => "http://www.pricemania.sk/katalog/auto-hifi/", })

    category_list = CategoriesParser::process_category_page(category)

    category.parent_id.should == parent_category.id
  end

  it "should set parent category for leaf category page" do
    parent_category = Category.create({:name => "Auto HiFi", :url => "http://www.pricemania.sk/katalog/auto-hifi/", })
    category = Category.create({:name => "Autorádia", :url => "http://www.pricemania.sk/katalog/autoradia-s-cd-mp3/"})

    category_list = CategoriesParser::process_category_page(category)

    category.parent_id.should == parent_category.id
  end
end
