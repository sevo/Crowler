# encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'peach'
require 'net/http'
require 'uri'
require 'mechanize'

module ProductParser

  ITEM_NUMBER = 200

  def self.all_products
    agent = Mechanize.new
    category_leafs = Category.find(:all).select {|c| c.children.empty?}
    
    #category_leafs.each do |c|
    category_leafs.peach (5) do |c|
      agent.get(c.url+"?catalog_numitems=200")
      process_product(c.url,agent,1)
    end
  end

  def self.process_product(base_url, agent, page = 1)

    agent.get(base_url+"?catalog_numitems=200")

    puts ""
    puts "processing: "+base_url
    puts "processing page: " + page.to_s
    process_list(agent.page.parser)

    page = 2

    while (process_list(agent.get(base_url+"?page=#{page}").parser) > 0)
      puts ""
      puts "processing next page"
      page +=1
    end

  end

  def self.process_list(doc)
    counter = 0

    doc.css("h2 a").each do |p|
      product = Product.find_or_create_by_url(p[:href])
      product.name = p.text
      puts p.text
      product.save
      counter += 1
    end

    doc.css("h3 a").each do |p|
      product = Product.find_or_create_by_url(p[:href])
      product.name = p.text
      puts p.text
      product.save
      counter += 1
    end

    counter
  end


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