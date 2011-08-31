namespace :categories_retrieval do
  desc "Get categories hierarchy"
  task :get_categories => :environment do
    require File.join(File.dirname(__FILE__), "categories_parser.rb")
    CategoriesParser::all_categories
  end

end