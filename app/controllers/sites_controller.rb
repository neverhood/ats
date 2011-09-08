class SitesController < ApplicationController
  def site_status
    site = Site.find params[:id]
    site_stat = site.nil? ? "unknown" : site.status
    # site_stat  = "error"
    #site_stat  = "idle"
    render :text=>site_stat
  end

  def site_row
    site = Site.find params[:id]
    render :partial=>"site_row", :locals=>{:site=>site}
  end

  def copy
    @site = Site.find params[:id]
    @site_from = Site.find params[:from_id]
    errors=[]
    confirms=[]
    @site_from.xpaths.each do |x|
      begin
        new_field = x.clone
        new_field.site_id = @site.id
        @site.xpaths.push new_field
        confirms.push "Field '#{new_field.available_field.field_name}' has been copied."
      rescue Exception=>e
        errors.push "Field '#{new_field.available_field.field_name}' has not been copied.<br>Probably it already exists."
      end
      if confirms.length > 0
        flash.notice = "<ul>"+(confirms.map { |c| "<li>#{c}</li>" }).join("\n") +"</ul>"
      end
      if errors.length > 0
        flash.error = "<ul>"+(errors.map { |e| "<li>#{e}</li>" }).join("\n") +"</ul>"
      end
    end
    respond_to do |format|
      format.html { redirect_to(@site) }
    end
  end

  # GET /sites
  # GET /sites.xml
  def index
    @sites = Site.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = Site.find(params[:id])
    @site_title = @site.nil? ? "unknown.." : @site.title
    @xpaths = @site.xpaths
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        #Xpath.create :field_name => "ref_code", :xpath => "none", :site_id=>@site.id
        #Xpath.create :field_name => "time_crawled", :xpath => "none", :site_id=>@site.id
        format.html { redirect_to(@site, :notice => 'Site was successfully created.') }
        format.xml { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to(@site, :notice => 'Site was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml { head :ok }
    end
  end

  def run
    @site = Site.find params[:id]
    #TODO remove next line when debug is over!
    @site.status="idle"
    if @site.active != "y"
      flash[:error] = "Site is not started, it is marked as not active. But you can edit that."
      redirect_to edit_site_path(@site)
    elsif @site.status != "idle" && !(@site.status =~ /.*?error.*?/)
      flash[:warning] = "Site is not started, seems like it is already running. However, if you believe it has hung up -- edit the status, set it to 'idle' and try again"
      redirect_to edit_site_path(@site)
    else
      Thread.new {
        start_working
      }
      flash[:notice] = "Site crawling has been launched"
      redirect_to(site_results_url @site)
    end
  rescue
    flash[:error] = "Unknown <epic> failure"
    redirect_to(sites_url)
  end

  protected
  def start_working
    @site.status = "Starting"
    @site.save

    require File.dirname(__FILE__)+"/../../lib/parsers/#{ @site.parser.class_name.to_s.underscore }"
    parser_class = Module.const_get(@site.parser.class_name.to_s)

    #some IDEs here will complain that "default constructor has no parameters"
    #disregard -- we use our custom constructors -- they take parameters
    parser = parser_class.new @site
    parser.run
  rescue Exception => e
    flash[:error] = "Unable to start parser: #{e.message}"
    puts "------------------------------Unable to start parser: #{e.message}"
    @site.status= "error: #{e.message}"
    @site.save!
  end
end
