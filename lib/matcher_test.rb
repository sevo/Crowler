module MatcherTest
  def self.test
    #products = Product.find(:all)
    products = Product.find_by_sql("SELECT distinct p.* FROM `shop_offers` as o join products as p on p.id = o.product_id")

    file = File.open("#{Rails.root}/tmp/results.txt",'a')

    counter = 0
    products[0..2000].each do |product|
      counter+=1
      puts "#{counter}\t|#{2000}"
      offers = ShopOffer.where(:product_id => product.id)
      offers.each do |o|
        #puts "product name: #{product.name}"
        #puts "offer name: #{o.name}"
        result = match(o.name.downcase)
        #puts "matched product: #{result[1]}"
        #puts "threshold: #{result[0]}"
        #puts "ZLE" unless result[1]==product.name
        #puts "OK" if result[1]==product.name
        #puts ""
        file.write "OK; #{result[0]}; #{result[1]}; #{product.name.downcase}\n" if result[1]==product.name.downcase
        file.write "ZLE; #{result[0]}; #{result[1]}; #{product.name.downcase}\n" unless result[1]==product.name.downcase
      end
    end

    
  end

  def self.prepare_database
    product_names = Product.find(:all).map{|p| p.name}

    file = File.open("#{Rails.root}/tmp/names_lower.txt",'w')
    product_names.each do |n|
       file.write n.downcase+"\n"
    end

    system("simstring -b -d #{Rails.root}/tmp/simstring/names_lower.db < #{Rails.root}/tmp/names_lower.txt")
  end

  def self.match(name)
    system("echo '#{name}' > #{Rails.root}/tmp/test_name.txt")
    find_match(name)
  end

  def self.find_match(name)
    old_threshold = 0
    threshold= 0.5
    first = ""
    second = ""
    last_match = ""

    until second .start_with? "1" and first.start_with? "\t"
      f= open "|simstring -d #{Rails.root}/tmp/simstring/names_lower.db -t #{threshold} -s jaccard < #{Rails.root}/tmp/test_name.txt"
      first = f.readline
      second = f.readline unless f.eof
      thresh_diff = old_threshold>threshold ? old_threshold-threshold : threshold-old_threshold

      last_match = first if first.start_with? "\t"

      old_threshold = threshold
      if first.starts_with? "0"
        threshold-=thresh_diff/2
      elsif second.starts_with? "\t"
        threshold+=thresh_diff/2
      end

      if thresh_diff < 0.05
        first = last_match#aby sa nestavalo ze pri breaku vrati ako najdeny produkt nezmyselny text
        break
      end
    end

    return threshold, first.strip
  end

end