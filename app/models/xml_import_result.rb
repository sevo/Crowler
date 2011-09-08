class XmlImportResult < ActiveRecord::Base
  belongs_to :product
  belongs_to :shop_offer
  belongs_to :xml_feed_handler
  belongs_to :most_common, :class_name => "Product"

  MATCH_DATABASE_FILE_PATH = "#{Rails.root}/tmp/simstring/products.db"
  MATCH_DATABASE_CONTENT_HELP_FILE_PATH = "#{Rails.root}/tmp/products.txt"
  MATCH_DATABASE_SEARCH_HELP_FILE_PATH = "#{Rails.root}/tmp/match_name.txt"


  def self.match(name,shop_id)#zatial len primitivne matchovanie, ak najde tak je ak nie tak vytvori novy
    result = XmlImportResult.create()

    offer = ShopOffer.find(:first, :conditions => {:name => name, :shop_id =>shop_id})
    #offer = ShopOffer.where(:first, :name => name, :shop_id => shop_id).first#_by_name_and_by_shop_id(name,shop_id)#najskor sa znazim najst offer podla zadaneho mena
    if offer != nil and offer.product_id != nil
      result.status = "linked"
      result.product_id = offer.product_id
      result.shop_offer = offer
      result.save
      return result
    end

    match,product_name = similar(name)#ked nieje offer, skusim matchnut na existujuci produkt a nastavit ho do most_common_id
    unless product_name == ""
      product = Product.find_by_name(product_name)
      result.status = "matched"
      result.most_common_id = product.id
      result.shop_offer = ShopOffer.create(:name => name, :shop_id => shop_id)
      result.match = match
      result.save
      return result
    end

    #ak neexistuje ponuka ani podobny produkt treba sa najskor rucne rozhodnut, kam sa priradi
    result.status = "unknown"
    result.shop_offer = ShopOffer.create(:name => name, :shop_id => shop_id)
    result.save

    result
  end

  def self.create_match_database
    product_names = Product.find(:all).map{|p| p.name}

    file = File.open(MATCH_DATABASE_CONTENT_HELP_FILE_PATH,'w')
    product_names.each do |n|
       file.write n.downcase+"\n"
    end

    f = open("|simstring -b -d #{MATCH_DATABASE_FILE_PATH} < #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}")
    text = f.read
    puts text
  end

  def self.insert_into_match_database(name)
    system("echo '#{name.downcase}' > #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}")
    system("simstring -b -d #{MATCH_DATABASE_FILE_PATH} < #{MATCH_DATABASE_CONTENT_HELP_FILE_PATH}")
  end

  #vracia pole, kde prvy prvok je podobnost a druhy je slovo (nazov) s ktorym je hladane slovo podobne, ak ziadne nenaslo tak je tam prazdny string
  def self.similar(name)
    system("echo '#{name.downcase}' > #{MATCH_DATABASE_SEARCH_HELP_FILE_PATH}")
    find_similar
  end

  private
  def self.find_similar(min_thrashold = 0.3)

    create_match_database unless File.exist? MATCH_DATABASE_FILE_PATH

    old_threshold = 0
    threshold= 0.5
    first = ""
    second = ""
    last_match = ""

    until second .start_with? "1" and first.start_with? "\t"
      f= open "|simstring -d #{MATCH_DATABASE_FILE_PATH} -t #{threshold} -s cosine < #{MATCH_DATABASE_SEARCH_HELP_FILE_PATH}"
      first = f.readline
      second = f.readline unless f.eof
      puts first
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
