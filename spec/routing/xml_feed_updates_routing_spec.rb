require "spec_helper"

describe XmlFeedHandlersController do
  describe "routing" do

    it "routes to #index" do
      get("/xml_feed_updates").should route_to("xml_feed_updates#index")
    end

    it "routes to #new" do
      get("/xml_feed_updates/new").should route_to("xml_feed_updates#new")
    end

    it "routes to #show" do
      get("/xml_feed_updates/1").should route_to("xml_feed_updates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/xml_feed_updates/1/edit").should route_to("xml_feed_updates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/xml_feed_updates").should route_to("xml_feed_updates#create")
    end

    it "routes to #update" do
      put("/xml_feed_updates/1").should route_to("xml_feed_updates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/xml_feed_updates/1").should route_to("xml_feed_updates#destroy", :id => "1")
    end

  end
end
