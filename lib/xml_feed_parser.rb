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


  def self.parse(document,shop,handler)

    result_text = "#{shop.name} #{DateTime.new.in_time_zone}"#text, ktory sa uvedie ako sumar k prebehnutemu importu
    feed = Feed.parse(document)

    entries_number = feed.entries.size
    result_text += "\n Total number of products: #{entries_number}"

    counter = 0
    skipped = 0

    feed.entries.each do |e|
      counter+=1

      if e.name == nil or e.price == nil or e.url == nil
        skipped +=1
        next
      end

      puts "#{counter}\t/#{entries_number} | #{e.name}"

      result = XmlImportResult.match(e.name,shop.id)

      offer = result.shop_offer

      offer.manufacturer = e.manufacturer unless e.manufacturer == nil
      offer.part_number = e.part_number unless e.part_number == nil
      offer.ean = e.ean unless e.ean == nil
      offer.name = e.name
      offer.cost = e.price.to_f
      offer.availability = e.availability unless e.availability == nil
      offer.shipping = e.shipping.to_f unless e.shipping == nil
      offer.url = e.url
      offer.image_url = e.picture unless e.picture == nil
      offer.description = e.description unless e.description == nil or e.description == ""

      offer.save

      result.xml_feed_handler = handler
      result.save
    end

    result_text+= "\n#{skipped} of products skipped (without required attributes)"

    handler.result = result_text
    handler.save
  end
  
end