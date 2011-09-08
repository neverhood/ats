class ResultsController < ApplicationController


  # GET /results
  # GET /results.xml
  def index
    @results = Result.search(params).page(params[:page])
    set_site
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @results }
    end
  end

  # GET /results/1
  # GET /results/1.xml
  def show
    @result = Result.find(params[:id])
    set_site
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @result }
    end
  end

  def html
    @result = Result.find(params[:id])
    render :text=> @result.html
  end

  # GET /results/new
  # GET /results/new.xml
  def new
    @result = Result.new
    set_site
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @result }
    end
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
    set_site
  end

  # POST /results
  # POST /results.xml
  def create
    @result = Result.new(params[:result])

    respond_to do |format|
      if @result.save
        format.html { redirect_to(@result, :notice => 'Result was successfully created.') }
        format.xml { render :xml => @result, :status => :created, :location => @result }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.xml
  def update
    @result = Result.find(params[:id])

    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to(@result, :notice => 'Result was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.xml
  def destroy
    @result = Result.find(params[:id])
    @result.destroy
    set_site
    respond_to do |format|
      format.html { redirect_to(site_results_url(@site)) }
      format.xml { head :ok }
    end
  end
end