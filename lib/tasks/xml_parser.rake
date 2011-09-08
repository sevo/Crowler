# encoding: UTF-8

namespace :xml_parser do
  desc "parse XML feed"
  task :parse_feed => :environment do
    #require 'open-uri'
    require File.join(File.dirname(__FILE__), "../xml_feed_parser.rb")
    shop = Shop.find_or_create_by_name_and_url("alza.sk","http://www.alza.sk")

    #XmlFeedParser::parse(open("http://www.compatak.sk/export/pricemania.xml"))
    XmlFeedParser::parse(open("/home/jakub/Desktop/pricemania.xml").read,shop,XmlFeedHandler.find(:first))
  end

  desc "Prepare database for search for similar strings"
  task :prepare_database => :environment do
    require File.join(File.dirname(__FILE__), "../xml_feed_parser.rb")
    XmlImportResult.create_match_database
  end

  desc "Prepare database for search for similar strings"
  task :match => :environment do
    require File.join(File.dirname(__FILE__), "../xml_feed_parser.rb")
    puts XmlImportResult.similar("KLIETKA PRE VTÁKY NINFA")
  end
end