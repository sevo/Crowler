require 'spec_helper'

describe "xml_file_downloads/new.html.erb" do
  before(:each) do
    assign(:xml_file_download, stub_model(XmlFileDownload,
      :url => "MyText",
      :path => "MyText"
    ).as_new_record)
  end

  it "renders new xml_file_download form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => xml_file_downloads_path, :method => "post" do
      assert_select "textarea#xml_file_download_url", :name => "xml_file_download[url]"
      assert_select "textarea#xml_file_download_path", :name => "xml_file_download[path]"
    end
  end
end
