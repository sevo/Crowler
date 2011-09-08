# encoding: UTF-8

namespace :matcher do
  desc "test of simstring string comparison"
  task :test => :environment do
    require File.join(File.dirname(__FILE__), "../matcher_test.rb")
    MatcherTest.test
  end

  desc "prepare database for test"
  task :prepare_database => :environment do
    require File.join(File.dirname(__FILE__), "../matcher_test.rb")
    MatcherTest.prepare_database
  end

  desc "find match"
  task :match => :environment do
    require File.join(File.dirname(__FILE__), "../matcher_test.rb")
    MatcherTest.match("Sony CDX-GT550UI, CD/MP3, USB čierne")
  end

end