# encoding: UTF-8

require 'nokogiri'
require 'open-uri'

module ShopsParser
  def self.all_shops
    base_url = "http://www.pricemania.sk/obchody/"

    #page = agent.get(base_url)
    
    process_list( base_url)

    page_number = 2

    while (process_list(base_url+"?page=#{page_number}") > 0)
      puts ""
      puts "processing page #{page_number}"
      page_number +=1
    end
    
  end


  def self.process_list(url)
    counter = 0
    doc = Nokogiri::HTML(open(url))

    doc.css("#orangeBorder .inshops a").each do |p|
      name = p.text
      detail = Nokogiri::HTML(open(PRICEMANIA_URL+p[:href]))
      trs = detail.xpath("//tr")
      url = ""

      trs.each do |tr|
        if tr.text[/Web:/]

          url = tr.at_xpath("td[2]").text[/[^\s]+/]
        end
      end

      if name != ""
        shop = Shop.find_or_create_by_name(name)
        shop.url = url
        puts name
        shop.save
        counter += 1
      end

    end

    counter
  end
  
end