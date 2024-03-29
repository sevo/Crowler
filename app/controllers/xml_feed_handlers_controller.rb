class XmlFeedHandlersController < ApplicationController
  # GET /xml_feed_handlers
  # GET /xml_feed_handlers.xml
  def index
    @search = XmlFeedHandler.search(params[:search])
    @handlers = @search.relation.all

    @xml_feed_handlers = XmlFeedHandler.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @xml_feed_handlers }
    end
  end

  # GET /xml_feed_handlers/1
  # GET /xml_feed_handlers/1.xml
  def show
    products = Product.find(:all)
    @xml_feed_handler = XmlFeedHandler.find(params[:id])
    @results = @xml_feed_handler.xml_import_results

    @select_array = []
    products[0..20].each do |p|
      @select_array << [p.name, p.id] if p.name.length < 30
      @select_array << [p.name[0..30]+" ...", p.id] unless p.name.length < 30
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @xml_feed_handler }
    end
  end

  # GET /xml_feed_handlers/new
  # GET /xml_feed_handlers/new.xml
  def new
    @xml_feed_handler = XmlFeedHandler.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @xml_feed_handler }
    end
  end

  # POST /xml_feed_handlers
  # POST /xml_feed_handlers.xml
  def create
    shop = Shop.find_by_name(params[:xml_feed_handler][:shop])
    @xml_feed_handler = XmlFeedHandler.create({:feed_path => params[:xml_feed_handler][:feed_path]})
    @xml_feed_handler.shop = shop

    respond_to do |format|
      if @xml_feed_handler.save
        format.html { redirect_to(@xml_feed_handler, :notice => 'Xml feed handler was successfully created.') }
        format.xml  { render :xml => @xml_feed_handler, :status => :created, :location => @xml_feed_handler }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @xml_feed_handler.errors, :status => :unprocessable_entity }
      end
    end
  end

  def run
    @xml_feed_handler = XmlFeedHandler.find(params[:id])
    @xml_feed_handler.run

    redirect_to(xml_feed_handlers_path)
  end

  def connect
    @handler = XmlFeedHandler.find(XmlFeedHandler.find(params[:id]))
    
    result_id = params[:result].first.first
    product_id = params[:product]

    result = XmlImportResult.find(result_id)
    product = Product.find(product_id)
    result.product = product
    result.status = "linked"
    result.save
    result.shop_offer.product = product
    result.shop_offer.save
    
    redirect_to(xml_feed_handler_path(@handler))
  end
  
end
