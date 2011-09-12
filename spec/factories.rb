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