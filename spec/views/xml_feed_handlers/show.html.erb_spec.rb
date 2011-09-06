require 'spec_helper'

describe "xml_feed_handlers/show.html.erb" do
  before(:each) do
    shop = Shop.create({:name => "alza.sk", :url => "http://www.alza.sk"})

    @xml_feed_handler = assign(:xml_feed_handler, stub_model(XmlFeedHandler,
      :feed_url => "MyText",
      :shop => shop,
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
