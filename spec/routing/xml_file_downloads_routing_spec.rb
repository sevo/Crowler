require "spec_helper"

describe XmlFileDownloadsController do
  describe "routing" do

    it "routes to #index" do
      get("/xml_file_downloads").should route_to("xml_file_downloads#index")
    end

    it "routes to #new" do
      get("/xml_file_downloads/new").should route_to("xml_file_downloads#new")
    end

    it "routes to #show" do
      get("/xml_file_downloads/1").should route_to("xml_file_downloads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/xml_file_downloads/1/edit").should route_to("xml_file_downloads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/xml_file_downloads").should route_to("xml_file_downloads#create")
    end

    it "routes to #update" do
      put("/xml_file_downloads/1").should route_to("xml_file_downloads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/xml_file_downloads/1").should route_to("xml_file_downloads#destroy", :id => "1")
    end

  end
end
