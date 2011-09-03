# encoding: UTF-8

require 'nokogiri'
require 'mechanize'

module OffersParser

  #vyberie zo strany ponuky vsetkych produktov (v databaze) vsetkymi obchodami
  def self.all_product_offers
    products = Product.find(:all)
    products.each do |p|
      product_detail(p)
    end
  end

  #prebehne detail produktu a vytvori prepojenia medzi obchodom a produktom
  def self.product_detail(product)
    base_url = product.url
    puts "processing product: "+product.name
    agent = Mechanize.new
    agent.get(base_url)
    



  end
end