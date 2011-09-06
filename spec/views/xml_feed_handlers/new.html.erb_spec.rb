require 'spec_helper'

describe "xml_feed_handlers/new.html.erb" do
  before(:each) do
    assign(:xml_feed_handler, stub_model(XmlFeedHandler,
      :feed_url => "MyText",
      :status => "MyString",
      :result => "MyText"
    ).as_new_record)
  end

  it "renders new xml_feed_handler form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => xml_feed_handlers_path, :method => "post" do
      assert_select "input#xml_feed_handler_feed_url", :name => "xml_feed_handler[feed_url]"
    end
  end
end
