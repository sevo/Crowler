class XmlFileDownloadsController < ApplicationController
  # GET /xml_file_downloads
  # GET /xml_file_downloads.xml
  def index
    @xml_file_downloads = XmlFileDownload.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @xml_file_downloads }
    end
  end

  # GET /xml_file_downloads/1
  # GET /xml_file_downloads/1.xml
  def show
    @xml_file_download = XmlFileDownload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @xml_file_download }
    end
  end

  # GET /xml_file_downloads/new
  # GET /xml_file_downloads/new.xml
  def new
    @xml_file_download = XmlFileDownload.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @xml_file_download }
    end
  end

  # POST /xml_file_downloads
  # POST /xml_file_downloads.xml
  def create
    shop = Shop.find_by_name(params[:xml_file_download][:shop])
    @xml_file_download = XmlFileDownload.create({:url => params[:xml_file_download][:url]})
    @xml_file_download.shop = shop

    respond_to do |format|
      if @xml_file_download.save
        format.html { redirect_to(@xml_file_download, :notice => 'Xml file download was successfully created.') }
        format.xml  { render :xml => @xml_file_download, :status => :created, :location => @xml_file_download }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @xml_file_download.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /xml_file_downloads/1
  # DELETE /xml_file_downloads/1.xml
  def destroy
    @xml_file_download = XmlFileDownload.find(params[:id])
    notice = 'Xml file was successfully deleted.'

    @xml_file_download.destroy

    respond_to do |format|
      format.html { redirect_to(xml_file_downloads_url :notice => notice) }
      format.xml  { head :ok }
    end
  end

end
