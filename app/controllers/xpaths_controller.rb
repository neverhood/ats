class XpathsController < ApplicationController
  # GET /xpaths
  # GET /xpaths.xml
  def index
    @xpaths = Xpath.where(["site_id=?", params[:site_id]]).page(params[:page])
    set_site
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @xpaths }
    end
  end

  # GET /xpaths/1
  # GET /xpaths/1.xml
  def show
    @xpath = Xpath.find(params[:id])
    set_site
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @xpath }
    end
  end

  # GET /xpaths/new
  # GET /xpaths/new.xml
  def new
    @xpath = Xpath.new
    @xpath.site_id = params[:site_id]
    set_site
    @xpath.pos = @site.xpaths.length + 1
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @xpath }
    end
  end

  # GET /xpaths/1/edit
  def edit
    @xpath = Xpath.find(params[:id])
    set_site
  end

  # POST /xpaths
  # POST /xpaths.xml
  def create
    @xpath = Xpath.new(params[:xpath])
    set_site
    respond_to do |format|
      if @xpath.save
        format.html { redirect_to(@site, :notice => "Field '#{@xpath.available_field.field_name}' was successfully created.") }
        format.xml { render :xml => @xpath, :status => :created, :location => @xpath }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @xpath.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /xpaths/1
  # PUT /xpaths/1.xml
  def update
    @xpath = Xpath.find(params[:id])
    set_site
    respond_to do |format|
      if @xpath.update_attributes(params[:xpath])
        format.html { redirect_to(@site, :notice => "Field '#{@xpath.available_field.field_name}' was successfully updated.") }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @xpath.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /xpaths/1
  # DELETE /xpaths/1.xml
  def destroy
    @xpath = Xpath.find(params[:id])
    @xpath.destroy
    set_site
    respond_to do |format|
      flash[:notice]="Field has been removed."
      format.html { redirect_to(@site) }
      format.xml { head :ok }
    end
  end
end
