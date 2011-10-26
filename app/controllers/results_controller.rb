class ResultsController < ApplicationController

  before_filter :arrange_customizations, :only => :customize

  # GET /results
  # GET /results.xml
  def index
    # @results = Result.search(params).page(params[:page])
    set_site
    @results = Result.for(@site).order('`time_crawled` DESC').page(params[:page])
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



  def customize
    @results = Result.select(@fields_to_select).
        from(@site.results_view).
        where(@filters).
        order(@order)

    @results = request.xhr?? @results.page(@page) : @results.all

    respond_to do |format|
      format.json { render :json => {:table => render_to_string(:partial => 'table')}, :layout => false }
      format.html { send_data Result.to_csv(@results, @fields), :type => 'text/csv',
                              :filename => "#{@site.title}_report_#{Time.now.strftime("%d-%m-%Y")}.csv",
                              :disposition => 'attachment' }
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

  private

  def arrange_customizations
    customizations = params[:results]
    @fields = customizations[:fields].split(',')
    @fields_to_select = (@fields + Result::PRESELECTED_FIELDS).
        map { |field| "`results`.`#{field}`" }
    @site = Site.find(customizations[:site_id])
    @order = "`#{customizations[:order][:by]}`" + ' ' + customizations[:order][:direction]
    @filters = parse_filters(customizations[:filters]) if customizations[:filters]
    @page = params[:results][:page]
  end

  def parse_filters(filters)
    # initially, `filters` is a hash, looking like so: { :ref_code => 'is_null', :description => 'starts_with:you gon like this place...' }
    sql = []

    filters.each do | key, value |

      if [ 'is_null', 'is_not_null' ].include? value
        sql << Result::FILTER_MAPPINGS[ value.to_sym ].call( key )
      elsif key == 'time_crawled'
        # expect the colons (e.g 14:55)
        values = value.split(':')
        sql << Result::FILTER_MAPPINGS[ values.first.to_sym ].call( key, values.slice(1, values.length).join(':') )
      else
        filter_type, filter_value = value.split(':')
        sql << Result::FILTER_MAPPINGS[ filter_type.to_sym ].call( key, filter_value )
      end

    end

    sql.join('AND')
  end

  #def to_csv(results)
  #
  #  if results && results.any?
  #    @fields.map { |field| "\"#{field}\"" }.join(',') + "\n" +            # Header
  #        results.map { |result_set| result_set.to_csv }.join("\n")   # Body
  #  else
  #    "No data available"
  #  end
  #
  #end

end
