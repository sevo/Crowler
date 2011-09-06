require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe XmlFeedHandlersController do

  # This should return the minimal set of attributes required to create a valid
  # XmlFeedhandler. As you add validations to XmlFeedhandler, be sure to
  # handler the return value of this method accordingly.
  before :each do
    Shop.create({:name => "alza.sk", :url => "Http://www.alza.sk"})
  end

  def valid_attributes
    {:shop_id => 1}
  end

  describe "GET index" do
    it "assigns all xml_feed_handlers as @xml_feed_handlers" do
      xml_feed_handler = XmlFeedHandler.create! valid_attributes
      get :index
      assigns(:xml_feed_handlers).should eq([xml_feed_handler])
    end
  end

  describe "GET show" do
    it "assigns the requested xml_feed_handler as @xml_feed_handler" do
      xml_feed_handler = XmlFeedHandler.create! valid_attributes
      get :show, :id => xml_feed_handler.id.to_s
      assigns(:xml_feed_handler).should eq(xml_feed_handler)
    end
  end

  describe "GET new" do
    it "assigns a new xml_feed_handler as @xml_feed_handler" do
      get :new
      assigns(:xml_feed_handler).should be_a_new(XmlFeedHandler)
    end
  end

  describe "POST create" do

    describe "with invalid params" do
      it "assigns a newly created but unsaved xml_feed_handler as @xml_feed_handler" do
        # Trigger the behavior that occurs when invalid params are submitted
        XmlFeedHandler.any_instance.stub(:save).and_return(false)
        post :create, :xml_feed_handler => {}
        assigns(:xml_feed_handler).should be_a_new(XmlFeedHandler)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        XmlFeedHandler.any_instance.stub(:save).and_return(false)
        post :create, :xml_feed_handler => {}
        response.should render_template("new")
      end
    end
  end

end
