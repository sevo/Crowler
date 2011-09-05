# encoding: UTF-8

require 'nokogiri'
require 'peach'
require 'mechanize'

module ProductParser

  ITEM_NUMBER = 200

  def self.all_products
    agent = Mechanize.new
    category_leafs = Category.find(:all).select {|c| c.children.empty?}
    page_count = 0
    
    #category_leafs.each do |c|
    category_leafs[1..10].peach (5) do |c|
      agent.get(c.url+"?catalog_numitems=200")
      page_count += process_product(c,agent,1)
    end
    puts "#{page_count} pages processed"
  end

  #spracuje jednu stranku kategorie (v ratane pokracovani zoznamu produktov)
  def self.process_product(category, agent, page = 1)
    base_url = category.url

    agent.get(base_url+"?catalog_numitems=200")

    puts ""
    puts "processing: "+base_url
    puts "processing page: " + page.to_s
    process_list(agent.page.parser,category)

    page = 2

    while (process_list(agent.get(base_url+"?page=#{page}").parser,category) > 0)
      puts ""
      puts "processing next page"
      page +=1
    end

    (page -1)
  end

  #spracuje jeden zoznam produktov
  def self.process_list(doc,category)
    counter = 0

    doc.css("h2 a").each do |p|
      product = Product.find_or_create_by_url(PRICEMANIA_URL+p[:href])
      product.name = p.text
      puts p.text
      product.category = category
      product.save
      counter += 1
    end

    doc.css("h3 a").each do |p|
      product = Product.find_or_create_by_url(PRICEMANIA_URL+p[:href])
      product.name = p.text
      puts p.text
      product.category = category
      product.save
      counter += 1
    end

    counter
  end

  #zisti celkovy pocet produktov na stranke pricemanie
  def self.products_number
    category_leafs = Category.find(:all).select {|c| c.children.empty?}
    sum = 0
    count = 0
    number = category_leafs.length
    category_leafs[1..100].peach (5) do |c|
      doc = Nokogiri::HTML(open(c.url))
      sum+=doc.at_css(".filter-button")[:value][/[0-9]+/].to_i unless doc.at_css(".filter-button")==nil
      count+=1
      puts count.to_s+ "\t/" +number.to_s
    end
    puts "sum: "+sum.to_s
  end
  
end