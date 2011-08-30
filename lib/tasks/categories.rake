namespace :categories_retrieval do
  desc "Get categories hierarchy"
  task :get_categories => :environment do
    require File.join(File.dirname(__FILE__), "categories_parser.rb")
    CategoriesParser::all_categories
  end

  desc "testing"
  task :process_page => :environment do#testing
    require File.join(File.dirname(__FILE__), "categories_parser.rb")
    CategoriesParser::process_category_page(Category.find_or_create_by_url("http://www.pricemania.sk/katalog/auto-moto/"))
  end

  desc "testing"
  task :process_home_page => :environment do#testing
    require File.join(File.dirname(__FILE__), "categories_parser.rb")
    CategoriesParser::process_home_page_for_category_pages
  end
end