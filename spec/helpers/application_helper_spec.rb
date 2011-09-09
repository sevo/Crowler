require 'spec_helper'
require "capybara/rails"

describe "xml_file_downloads/show.html.erb" do
  describe "ApplicationHelper" do

    before :each do
      shop = Shop.create({:name => "alza.sk", :url => "Http://www.alza.sk"})
      XmlFileDownload.create(:shop => shop, :url => "http://www.sme.sk/index.html", :path => "/tmp/1.html")
      XmlFileDownload.create(:shop => shop, :url => "http://www.google.sk/index.html", :path => "/dev/null")
      XmlFileDownload.create(:shop => shop, :url => "http://www.yahoo.com/index.html", :path => "/tmp/2.html")
    end

    it "should render index page" do
      visit '/xml_file_downloads'
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      find(:xpath, "//table/tr[2]").should have_content("http://www.sme.sk/index.html")
      find(:xpath, "//table/tr[2]").should have_content("enqueued")
      find(:xpath, "//table/tr[2]").should have_content("/tmp/1.html")
      find(:xpath, "//table/tr[2]").should have_link("Show")
      find(:xpath, "//table/tr[2]").should have_link("Destroy")

      find(:xpath, "//table/tr[3]").should have_content("http://www.google.sk/index.html")
      find(:xpath, "//table/tr[3]").should have_content("enqueued")
      find(:xpath, "//table/tr[3]").should have_content("/dev/null")

      find(:xpath, "//table/tr[4]").should have_content("http://www.yahoo.com/index.html")
      find(:xpath, "//table/tr[4]").should have_content("enqueued")
      find(:xpath, "//table/tr[4]").should have_content("/tmp/2.html")

      #save_and_open_page
    end

    it "should order by url" do
      visit '/xml_file_downloads'
      click_link "url"

      find(:xpath, "//table/tr[2]").should have_content("http://www.google.sk/index.html")
      find(:xpath, "//table/tr[3]").should have_content("http://www.sme.sk/index.html")
      find(:xpath, "//table/tr[4]").should have_content("http://www.yahoo.com/index.html")
      
    end

    it "should filter" do
      visit '/xml_file_downloads'
      fill_in "search_url_contains",:with => ".sk"
      click_button "filter"

      find(:xpath, "//table/tr[2]").should have_content("http://www.sme.sk/index.html")
      find(:xpath, "//table/tr[3]").should have_content("http://www.google.sk/index.html")
    end

    it "can skip filter form" do
      visit '/xml_feed_handlers'

      page.should_not have_xpath("/html/body/form/table/tbody/tr/td[3]//input")
    end

    it "can add class to <td>" do
      visit '/xml_feed_handlers'

      page.should have_xpath("//td[@class='result']")
    end

    describe "different forms of input" do
      it "provide select box" do
        visit '/xml_feed_handlers'

        page.should have_xpath("//select")
      end

      it "provide textbox" do
        visit '/xml_file_downloads'

        page.should have_xpath("//input[@type='text']")
      end
    end
  end
end