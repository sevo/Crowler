# encoding: UTF-8

require 'nokogiri'
require 'open-uri'

module XmlFeedParser

  def self.parse(document,shop)
    doc = Nokogiri::XML(document)
    products = doc.xpath("/Products/product")

    puts "Celkovy pocet produktov: #{products.size}"

    counter = 0
    skipped = 0
    
    products.each do |p|
      counter += 1
      #ak chybaju nevyhnutne udaje tak preskoc zaznam
      if p.at_xpath("name") == nil or p.at_xpath("price") == nil or p.at_xpath("url") == nil
        skipped +=1
        puts "product skipped"
        next
      end

      puts "#{counter}\t/#{products.size} #{p.at_xpath("name").text}"

      product = Product.match(p.at_xpath("name").text)
      product.manufacturer = p.at_xpath("manufacturer").text unless p.at_xpath("manufacturer") == nil
      product.part_number = p.at_xpath("part_number").text unless p.at_xpath("part_number") == nil
      product.ean = p.at_xpath("ean").text unless p.at_xpath("ean") == nil
      product.save

      ProductImage.find_or_create_by_product_id_and_url(product.id,p.at_xpath("picture").text) unless p.at_xpath("picture") == nil

      offer = ShopOffer.find_or_create_by_product_id_and_shop_id(product.id,shop.id)
      offer.name = name
      offer.cost = p.at_xpath("price").text.to_f
      offer.availability = p.at_xpath("availability").text unless p.at_xpath("availability") == nil
      offer.shipping = p.at_xpath("shipping").text.to_f unless p.at_xpath("shipping") == nil
      offer.url = p.at_xpath("url").text
      offer.save

      unless p.at_xpath("description") == nil or p.at_xpath("description").text == ""
        product_description = ProductDescription.find_or_create_by_product_id_and_shop_id(product.id,shop.id)
        product_description.description = p.at_xpath("description").text
        product_description.save
      end

    end

    puts "#{skipped} products skipped"
  end
  
end