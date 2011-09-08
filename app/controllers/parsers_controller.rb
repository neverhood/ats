class ParsersController < ApplicationController
  def copy
    @parser = Parser.find params[:id]
    @parser_from = Parser.find params[:from_id]
    errors=[]
    confirms=[]
    @parser_from.available_fields.each do |a_f|
      begin
        new_field = a_f.clone
        new_field.parser_id = @parser.id
        @parser.available_fields.push new_field
        confirms.push "Field '#{new_field.field_name}' has been copied."
      rescue Exception => e
        errors.push "Field '#{new_field.field_name}' has not been copied.<br>Error: #{e}"
      end
      if confirms.length > 0
        flash.notice = "<ul>"+(confirms.map { |c| "<li>#{c}</li>" }).join("\n") +"</ul>"
      end
      if errors.length > 0
        flash.error = "<ul>"+(errors.map { |e| "<li>#{e}</li>" }).join("\n") +"</ul>"
      end
    end
    respond_to do |format|
      format.html { redirect_to(@parser) }
    end
  end

  # GET /parsers
  # GET /parsers.xml
  def index
    @parsers = Parser.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @parsers }
    end
  end

  # GET /parsers/1
  # GET /parsers/1.xml
  def show
    @parser = Parser.find(params[:id])
    @available_fields = @parser.available_fields
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @parser }
    end
  end

  # GET /parsers/new
  # GET /parsers/new.xml
  def new
    @parser = Parser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @parser }
    end
  end

  # GET /parsers/1/edit
  def edit
    @parser = Parser.find(params[:id])
  end

  # POST /parsers
  # POST /parsers.xml
  def create
    @parser = Parser.new(params[:parser])

    respond_to do |format|
      if @parser.save
        ref_code = AvailableField.new
        ref_code.field_name = "ref_code"
        @parser.available_fields.push ref_code

        html= AvailableField.new
        html.field_name = "html"
        @parser.available_fields.push html

        format.html { redirect_to(@parser, :notice => 'Parser was successfully created.') }
        format.xml { render :xml => @parser, :status => :created, :location => @parser }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @parser.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /parsers/1
  # PUT /parsers/1.xml
  def update
    @parser = Parser.find(params[:id])

    respond_to do |format|
      if @parser.update_attributes(params[:parser])
        format.html { redirect_to(@parser, :notice => 'Parser was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @parser.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /parsers/1
  # DELETE /parsers/1.xml
  def destroy
    @parser = Parser.find(params[:id])
    @parser.destroy

    respond_to do |format|
      format.html { redirect_to(parsers_url) }
      format.xml { head :ok }
    end
  end
end
