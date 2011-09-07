require 'spec_helper'

describe "xml_file_downloads/show.html.erb" do
  before(:each) do
    @xml_file_download = assign(:xml_file_download, stub_model(XmlFileDownload,
      :url => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
