Factory.define :shop do |f|
  f.sequence(:name) { |n| "alza#{n}.sk" }
  f.url { |u| "http://www.#{u.name}" }
end

Factory.define :shop_offer do |f|
  f.name "Foo"
  f.association :shop
  f.association :product
end

Factory.define :product do |f|
  f.name "Sencor SCD 7405BMR"
end

Factory.define :xml_feed_handler do |f|
  f.feed_path "/home/jakub/Ubuntu_One/RubymineProjects/Crowler/spec/tmp/feed.xml"
  f.association :shop
end

Factory.define :xml_file_download do |f|
  f.url "http://c.sme.sk/imgs/pager/logo.gif"
  f.association :shop
end