# encoding: UTF-8

require 'spec_helper'
require "#{RAILS_ROOT}/lib/shops_parser"

describe ShopsParser do
  it "should create shop" do
    count = ShopsParser::process_list("http://www.pricemania.sk/obchody/")

    count.should == 20
    Shop.find(:all).count.should == 20
    Shop.find_by_name("alza.sk").url.should == "http://www.alza.sk"
  end

  it "should create shops from next pages" do
    count = ShopsParser::process_list("http://www.pricemania.sk/obchody/?page=10")

    count.should == 20
    Shop.find(:all).count.should == 20
    Shop.find_by_name("eLIMAL.sk - Najvýhodnejší nákup na internete").url.should == "http://www.eLIMAL.sk/"
  end




  
end