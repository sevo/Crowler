class ShopOffer < ActiveRecord::Base
  belongs_to :shop
  has_many :xml_import_results
  belongs_to :product
end
