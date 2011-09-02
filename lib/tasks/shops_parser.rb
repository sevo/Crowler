# encoding: UTF-8

require 'nokogiri'
require 'mechanize'

module ShopsParser
  def self.all_shops
    base_url = "http://www.pricemania.sk/obchody/"
    agent = Mechanize.new
    agent.get(base_url)
    
    process_list(agent.page.parser)

    page = 2

    while (process_list(agent.get(base_url+"?page=#{page}").parser) > 0)
      puts ""
      puts "processing page #{page}"
      page +=1
    end
    
  end


  def self.process_list(doc)
    counter = 0

    doc.css("#orangeBorder .inshops a").each do |p|
      shop = Shop.find_or_create_by_url(p[:href])
      shop.name = p.text
      puts p.text
      shop.save
      counter += 1
    end

    counter
  end
  
end