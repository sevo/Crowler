class Shop < ActiveRecord::Base
  has_many :shop_offers
  has_many :product_descriptions
end
