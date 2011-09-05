# encoding: UTF-8

namespace :xml_parser do
  desc "parse XML feed"
  task :parse_feed => :environment do
    #require 'open-uri'
    require File.join(File.dirname(__FILE__), "../xml_feed_parser.rb")
    shop = Shop.find_or_create_by_name_and_url("alza.sk","http://www.alza.sk")

    #XmlFeedParser::parse(open("http://www.compatak.sk/export/pricemania.xml"))
    XmlFeedParser::parse(open("/home/jakub/Desktop/pricemania.xml"),shop)
  end
end