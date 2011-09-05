class Product < ActiveRecord::Base
  belongs_to :category
  has_many :product_descriptions
  has_many :product_images

  def self.match(name)#zatial len primitivne matchovanie, ak najde tak je ak nie tak vytvori novy
    product = self.find_or_create_by_name(name)
    product
  end
end
