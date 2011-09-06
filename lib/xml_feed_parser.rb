# encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'sax-machine'

module XmlFeedParser

    # Class for information associated with content parts in a feed.
  #  Ex: <content type="text">sample</content>
  #  instance.type will be "text", instance.text will be "sample"
  class FeedContent
    include SAXMachine
    attribute :type
    value :text
  end

  # Class for parsing an atom entry out of a feedburner atom feed
  class FeedEntry
    include SAXMachine
    element :name
    element :description
    element :price
    element :manufacturer
    element :url
    element :picture
    element :availability
    element :part_number
    element :category
    element :shipping
    element :ean
    element :content, :class => FeedContent
    parent :parent
  end

  # Class for parsing Atom feeds
  class Feed
    include SAXMachine
    elements :product, :as => :entries, :class => FeedEntry
  end


  def self.parse(document,shop)
    feed = Feed.parse(document)

    entries_number = feed.entries.size
    puts "Celkovy pocet produktov: #{entries_number}"
    
    counter = 0
    skipped = 0

    feed.entries.each do |e|
      counter+=1

      if e.name == nil or e.price == nil or e.url == nil
        skipped +=1
        puts "product skipped"
        next
      end

      puts "#{counter}\t/#{entries_number} | #{e.name}"

      product = Product.match(e.name)
      product.manufacturer = e.manufacturer unless e.manufacturer == nil
      product.part_number = e.part_number unless e.part_number == nil
      product.ean = e.ean unless e.ean == nil
      product.save

      ProductImage.find_or_create_by_product_id_and_url(product.id,e.picture) unless e.picture == nil

      offer = ShopOffer.find_or_create_by_product_id_and_shop_id(product.id,shop.id)
      offer.name = e.name
      offer.cost = e.price.to_f
      offer.availability = e.availability unless e.availability == nil
      offer.shipping = e.shipping.to_f unless e.shipping == nil
      offer.url = e.url
      offer.save

      unless e.description == nil or e.description == ""
        product_description = ProductDescription.find_or_create_by_product_id_and_shop_id(product.id,shop.id)
        product_description.description = e.description
        product_description.save
      end

    end

    puts "#{skipped} products skipped"
  end
  
end