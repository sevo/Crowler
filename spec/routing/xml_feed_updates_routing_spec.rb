require "spec_helper"

describe XmlFeedHandlersController do
  describe "routing" do

    it "routes to #index" do
      get("/xml_feed_handlers").should route_to("xml_feed_handlers#index")
    end

    it "routes to #new" do
      get("/xml_feed_handlers/new").should route_to("xml_feed_handlers#new")
    end

    it "routes to #show" do
      get("/xml_feed_handlers/1").should route_to("xml_feed_handlers#show", :id => "1")
    end

    it "routes to #create" do
      post("/xml_feed_handlers").should route_to("xml_feed_handlers#create")
    end

    it "routes to #connect" do
      Factory(:xml_feed_handler)
      get("/xml_feed_handlers/1/connect").should route_to("xml_feed_handlers#connect", :id => "1")
    end

  end
end
