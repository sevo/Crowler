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
    list_to_process = process_home_page_for_category_pages #zoznam ktory obsahuje instancie treidy Page, stranky, ktore sa maju spracovat
    processed_list = []
    categories = []

    while !list_to_process.empty?
      page_to_process = list_to_process.first

      puts "list to process >>" + list_to_process.to_s
      puts "page to process >>" + page_to_process.to_s
      puts "processed list >>" + processed_list.to_s
      puts ""

      new_list = page_to_process.process_category_page
      puts "new list" + new_list.to_s
      puts ""
      new_list.each do |i|
        unless list_to_process.any? {|li| li.url == i.url} or processed_list.any? {|li| li.url == i.url}
          list_to_process << i
        end
      end
      categories << page_to_process.category_name


      list_to_process.delete_at(0)
      processed_list << page_to_process
    end

    categories
  end

  def self.process_category_page(category)
    #category_pages_list = []

    doc = Nokogiri::HTML(open(category.url))
    parent_url_ending = doc.xpath("//div[@id='breadcrumbs']/a")[-2]['href']
    parent_category = Category.find_or_create_by_url(Page.base_url[0...-1]+parent_url_ending)
    category.parent = parent_category
    category.save

    most_visited = doc.xpath("//div[@class='most_visited']")

    most_visited.each do |mv|
      url_ending = mv.at_xpath('a')['href']
      full_url = Page.base_url[0...-1] + url_ending
      name = mv.text.strip
      #category_pages_list << Page.new(name, full_url)

      new_category = Category.find_or_create_by_url(full_url)
      new_category.name = name
      new_category.save
    end

    #category_pages_list
  end

  def self.process_home_page_for_category_pages
    url = "http://www.pricemania.sk/"
    home = Category.create({:name => 'home', :url => url})

    #category_pages = {}
    doc = Nokogiri::HTML(open(url))
    category_divs = doc.xpath("//div[@class='text-box-links']")
    category_divs.each do |cd|
      name = cd.at_xpath("div/h2").text
      url_ending = cd.at_xpath("div/h2/a")['href']
      full_url = Page.base_url[0...-1]+url_ending if url.end_with?("/")
      #category_pages[full_url] = Page.new(name,full_url)
      Category.create({:name => name, :url => full_url, :parent => home})
    end

    #category_pages
  end


end