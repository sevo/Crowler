class Shop < ActiveRecord::Base
  has_many :shop_offers
  has_many :product_descriptions
  has_many :xml_feed_handlers
end
