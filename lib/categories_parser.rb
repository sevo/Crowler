require 'nokogiri'
require 'open-uri'

module CategoriesParser

  class Page
    attr_accessor :category_name, :url, :parent_url

    def initialize (category_name = "home", url = "/", parent_url = "")
      @category_name = category_name
      @url = url
      @parent_url = parent_url
    end

    def self.base_url
      "http://www.pricemania.sk/"
    end
  end

  def self.all_categories
    puts "all_categories"
    new_categories = process_home_page_for_category_pages #zoznam ktory obsahuje instancie treidy Page, stranky, ktore sa maju spracovat
    categories_to_process = {}
    processed_categories = {}
    all_categories = []

    new_categories.each do |c|
      categories_to_process[c] = true
      all_categories << c
    end

    while !categories_to_process.empty?
      category = categories_to_process.first[0]
      
      new_list = process_category_page(category)

      new_list.each do |c|
        unless categories_to_process.has_key? c or processed_categories.has_key? c
          categories_to_process[c] = true
          all_categories << c
        end
      end

      categories_to_process.delete category
      processed_categories[category] = true
    end

    all_categories
  end

  def self.process_category_page(category)
    puts "processing category page: " + category.url

    category_list = []

    doc = Nokogiri::HTML(open(category.url))

    #ziska nazov kategorie
    name = doc.xpath("//div[@class='in-content']/h1").text
    unless name.nil? or name == ""
      category.name = name
      category.save
    end

    #ziska nadradenu kategoriu
    unless doc.xpath("//div[@id='breadcrumbs']/a")[-2].nil?
      parent_url_ending = doc.xpath("//div[@id='breadcrumbs']/a")[-2]['href']
      parent_category = Category.find_or_create_by_url(Page.base_url[0...-1]+parent_url_ending)
      category.parent = parent_category
      category.save
      category_list << parent_category #co ked sa vytvorila nova kategoria
    end

    #najde najnavstevovanejsie podkategorie
    most_visited = doc.xpath("//div[@class='most_visited']")

    most_visited.each do |mv|
      url_ending = mv.at_xpath('a')['href']

      if Page.base_url.end_with?("/")
        full_url = Page.base_url[0...-1]+url_ending
      else
        full_url = Page.base_url+url_ending
      end

      name = mv.text.strip

      new_category = Category.find_or_create_by_url(full_url)
      new_category.name = name
      new_category.save

      category_list << new_category #ked sa vytvori nova kategoria, treba ju este spracovat
    end

    #najde ostatne podkategorie
    others = doc.xpath("//div[@class='text-box-links']")

    others.each do |o|
      next if o.at_xpath("h2").nil?#na hlavnej stranke takyto element nieje, a ta uz je spracovana
      
      name = o.at_xpath("h2").text
      url_ending = o.at_xpath("h2/a")['href']

      if Page.base_url.end_with?("/")
        full_url = Page.base_url[0...-1]+url_ending
      else
        full_url = Page.base_url+url_ending
      end

      new_category = Category.find_or_create_by_url(full_url)
      new_category.name = name
      new_category.save

      category_list << new_category
    end


    category_list
  end

  def self.process_home_page_for_category_pages
    puts "process home page"
    
    category_list = []

    home = Category.create({:name => 'home', :url => Page.base_url})

    doc = Nokogiri::HTML(open(Page.base_url))
    category_divs = doc.xpath("//div[@class='text-box-links']")

    category_divs.each do |cd|
      name = cd.at_xpath("div/h2").text
      url_ending = cd.at_xpath("div/h2/a")['href']
      
      if Page.base_url.end_with?("/")
        full_url = Page.base_url[0...-1]+url_ending
      else
        full_url = Page.base_url+url_ending
      end

      new_category = Category.create({:name => name, :url => full_url, :parent => home})
      category_list << new_category
    end

    category_list
  end
  
end