# encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'peach'

module OffersParser

  #vyberie zo strany ponuky vsetkych produktov (v databaze) vsetkymi obchodami
  def self.all_product_offers
    products = Product.find(:all)
    products[0..200].peach(5) do |p|
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
      shop_name = o.xpath("tr[1]/td[5]").text.gsub("\n"," ").strip[/[^\t]+$/]
      shop_name = shop_name[0...-3] if shop_name.ends_with?("...")
      shop = Shop.find(:all, :conditions => ["name LIKE ?",shop_name+"%"])#_by_name(shop_name)

      offer = ShopOffer.find_or_create_by_product_id_and_shop_id(product.id,shop.first.id)
      offer.name = offer_name
      offer.save

    end

  end
end
