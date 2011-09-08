# encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'sax-machine'

module XmlFeedParser

  MATCH_DATABASE_FILE_PATH = "#{Rails.root}/tmp/simstring/products.db"
  MATCH_DATABASE_CONTENT_HELP_FILE_PATH = "#{Rails.root}/tmp/products.txt"
  MATCH_DATABASE_SEARCH_HELP_FILE_PATH = "#{Rails.root}/tmp/match_name.txt"

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

    result_text = "#{shop.name} #{DateTime.new.in_time_zone}"
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

      result = XmlImportResult.match(e.name)

      if result.status == "unknown"
        offer = Shop.create(:shop => shop)
      else
        offer = ShopOffer.find_or_create_by_product_id_and_shop_id(result.product.id,shop.id)
      end

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

      result.shop_offer = offer
      result.xml_feed_handler = handler
      result.save

      unless result.status == "unknown"
        offer.product = result.product
        offer.save
      end

    end

    result_text+= "\n#{skipped} of products skipped (without required attributes)"

    handler.result = result_text
    handler.save
  end

  def self.create_match_database
    product_names = Product.find(:all).map{|p| p.name}

    file = File.open(MATCH_DATABASE_CONTENT_HELP_FILE_PATH,'w')
    product_names.each do |n|
       file.write n.downcase+"\n"
    end

    system("simstring -b -d #{MATCH_DATABASE_FILE_PATH} < #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}")
  end

  def self.insert_to_match_database(name)
    system("echo '#{name}' > #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}")
    system("simstring -b -d #{MATCH_DATABASE_FILE_PATH} < #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}")
  end

  #vracia pole, kde prvy prvok je podobnost a druhy je slovo (nazov) s ktorym je hladane slovo podobne, ak ziadne nenaslo tak je tam prazdny string
  def self.match(name)
    system("echo '#{name}' > #{MATCH_DATABASE_SEARCH_HELP_FILE_PATH}")
    find_match(name)
  end

  private
  def self.find_match(name, min_thrashold = 0.3)
    old_threshold = 0
    threshold= 0.5
    first = ""
    second = ""
    last_match = ""

    until second .start_with? "1" and first.start_with? "\t"
      f= open "|simstring -d #{MATCH_DATABASE_FILE_PATH} -t #{threshold} -s cosine < #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}"
      first = f.readline
      second = f.readline unless f.eof
      thresh_diff = old_threshold>threshold ? old_threshold-threshold : threshold-old_threshold

      last_match = first if first.start_with? "\t"

      if thresh_diff < 0.05
        first = last_match#aby sa nestavalo ze pri breaku vrati ako najdeny produkt nezmyselny text
        break
      end

      if threshold < min_thrashold #nenasiel sa vysledok lepsi ako minimalny thrashold
        first = ""
        break
      end

      old_threshold = threshold
      if first.starts_with? "0"
        threshold-=thresh_diff/2
      elsif second.starts_with? "\t"
        threshold+=thresh_diff/2
      end
    end

    return threshold, first.strip
  end
  
end