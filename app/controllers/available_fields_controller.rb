class AvailableFieldsController < ApplicationController
  # GET /available_fields
  # GET /available_fields.xml
  def index
    @available_fields = AvailableField.where(["parser_id=?", params[:parser_id]]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @available_fields }
    end
  end

  # GET /available_fields/1
  # GET /available_fields/1.xml
  def show
    @available_field = AvailableField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @available_field }
    end
  end

  # GET /available_fields/new
  # GET /available_fields/new.xml
  def new
    @available_field = AvailableField.new
    @available_field.parser_id = params[:parser_id]
    set_parser
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @available_field }
    end
  end

  # GET /available_fields/1/edit
  def edit
    @available_field = AvailableField.find(params[:id])
    set_parser
  end

  # POST /available_fields
  # POST /available_fields.xml
  def create
    @available_field = AvailableField.new(params[:available_field])
    set_parser
    respond_to do |format|
      if @available_field.save
        format.html { redirect_to(@parser, :notice => "Field '#{@available_field.field_name}' was successfully created.") }
        format.xml { render :xml => @available_field, :status => :created, :location => @available_field }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @available_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /available_fields/1
  # PUT /available_fields/1.xml
  def update
    @available_field = AvailableField.find(params[:id])
    set_parser
    if  @available_field.field_name == "ref_code"
      flash[:warning] = "Field 'ref_code' is system specific and can not be updated"
      redirect_to(@parser)
      return
    end

    respond_to do |format|
      if @available_field.update_attributes(params[:available_field])
        format.html { redirect_to(@parser, :notice => "Field '#{@available_field.field_name}' was successfully updated.") }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @available_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /available_fields/1
  # DELETE /available_fields/1.xml
  def destroy
    @available_field = AvailableField.find(params[:id])
      set_parser
    if  @available_field.field_name == "ref_code"
      flash[:warning] = "Field 'ref_code' is system specific and can be deleted only together with the Parser."
      redirect_to(@parser)
      return
    end
    @available_field.destroy

    respond_to do |format|
      format.html { redirect_to(@parser) }
      format.xml { head :ok }
    end
  end
end
