require 'spec_helper'

describe "xml_feed_updates/show.html.erb" do
  before(:each) do
    @xml_feed_update = assign(:xml_feed_update, stub_model(XmlFeedHandler,
      :url => "MyText",
      :status => "Status",
      :result => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
