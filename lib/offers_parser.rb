# encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'peach'

module OffersParser

  #vyberie zo strany ponuky vsetkych produktov (v databaze) vsetkymi obchodami
  def self.all_product_offers
    products = Product.find(:all)
    products.peach(5) do |p|
      product_detail(p)
    end
  end

  #prebehne detail produktu a vytvori prepojenia medzi obchodom a produktom
  def self.product_detail(product)
    puts "processing product: "+product.name
    doc = Nokogiri::HTML(open(product.url))
    offers = doc.xpath("//table[@class='offers-row']")
    offers.each do |o|
      offer_name = o.xpath("tr[1]/td[3]").text.strip
      offer_cost = o.xpath("tr[1]/td[4]").text.strip[/^\S+/].gsub(",",".")
      shop_name = o.xpath("tr[1]/td[5]").text.gsub("\n"," ").strip[/[^\t]+$/]
      shop = Shop.find_by_name(shop_name)
      puts "Shop name: #{shop_name}"
      offer = ShopOffer.find_or_create_by_product_id_and_shop_id(product.id,shop.id)
      offer.name = offer_name
      offer.cost = offer_cost
      offer.save
    end

  end
end