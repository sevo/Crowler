class Product < ActiveRecord::Base
  belongs_to :category
  has_many :xml_import_results
  has_many :shop_offers
end
