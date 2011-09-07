class XmlImportResult < ActiveRecord::Base
  belongs_to :product
  belongs_to :shop_offer
  belongs_to :xml_feed_handler

  def self.match(name)#zatial len primitivne matchovanie, ak najde tak je ak nie tak vytvori novy
    product = Product.find_by_name(name)
    result = XmlImportResult.create()

    if product.nil?
      result.status = "created"
      result.product = Product.create(:name => name)
      result.save
    else
      result.status = "linked"
      result.product = product
      result.save
    end

    result
  end
end
