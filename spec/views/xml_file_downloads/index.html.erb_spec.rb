require 'spec_helper'

describe "xml_file_downloads/index.html.erb" do
  before(:each) do
    Factory(:xml_file_download, :url => "http://url.sk")
  end

  it "renders a list of xml_file_downloads" do
    visit '/xml_file_downloads'
    page.should have_content "http://url.sk"
  end
end
