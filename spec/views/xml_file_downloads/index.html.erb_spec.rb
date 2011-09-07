require 'spec_helper'

describe "xml_file_downloads/index.html.erb" do
  before(:each) do
    assign(:xml_file_downloads, [
      stub_model(XmlFileDownload,
        :url => "MyText"
      ),
      stub_model(XmlFileDownload,
        :url => "MyText"
      )
    ])
  end

  it "renders a list of xml_file_downloads" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
