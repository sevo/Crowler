require 'spec_helper'

describe "xml_feed_updates/edit.html.erb" do
  before(:each) do
    @xml_feed_update = assign(:xml_feed_update, stub_model(XmlFeedHandler,
      :url => "MyText",
      :status => "MyString",
      :result => "MyText"
    ))
  end

  it "renders the edit xml_feed_update form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => xml_feed_updates_path(@xml_feed_update), :method => "post" do
      assert_select "textarea#xml_feed_update_url", :name => "xml_feed_update[url]"
      assert_select "input#xml_feed_update_status", :name => "xml_feed_update[status]"
      assert_select "textarea#xml_feed_update_result", :name => "xml_feed_update[result]"
    end
  end
end
