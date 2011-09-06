require 'spec_helper'

describe "xml_feed_updates/index.html.erb" do
  before(:each) do
    assign(:xml_feed_handlers, [
      stub_model(XmlFeedHandler,
        :url => "MyText",
        :status => "Status",
        :result => "MyText"
      ),
      stub_model(XmlFeedHandler,
        :url => "MyText",
        :status => "Status",
        :result => "MyText"
      )
    ])
  end

  it "renders a list of xml_feed_updates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
