require 'spec_helper'

describe "xml_feed_handlers/index.html.erb" do
  before(:each) do
    shop = Shop.create({:name => "alza.sk", :url => "http://www.alze.sk"})
    handler1 = XmlFeedHandler.create({:feed_path => "/home/jj", :shop => shop, :status => "stav", :result=> "vysledok"})
    handler2 = XmlFeedHandler.create({:feed_path => "/home/jj", :shop => shop, :status => "stav", :result=> "vysledok"})

    assign(:xml_feed_handlers, [
      handler1,
      handler2
    ])
  end

  it "renders a list of xml_feed_handlers" do
    render
    assert_select "tr>td", :text => "/home/jj", :count => 2
    assert_select "tr>td", :text => "alza.sk", :count => 2
    assert_select "tr>td", :text => "vysledok", :count => 2
  end
end
