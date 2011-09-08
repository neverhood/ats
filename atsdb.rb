DB_SERVER_CONNECTION_STRING = "DBI:ODBC:MYSQL"
######################## NO EDITING PAST THIS LINE ####################################################################
require 'dbi'
require 'rubygems'
require 'odbc'
require 'mechanize'
begin
  # connect to the MSSQL server
  dbh = DBI.connect(DB_SERVER_CONNECTION_STRING)

  #fill in sites structure
  sites = []
  rows = dbh.select_all("SELECT j.*, w.name AS parser FROM sites AS j LEFT JOIN parsers AS w ON j.parser_id = w.id  WHERE j.active='y' OR j.active='Y' ORDER BY j.id")
  rows.each do |row|
    site={}
    [:id, :active, :title, :parser, :save_path, :url, :save_html].each do |property|
      site[property] = row[property.to_s]
    end
    csv_fields=[]
    csv_xpath={}
    fields_sql="SELECT field_name, xpath FROM xpath WHERE site_id=?"
    fields_rows = dbh.select_all fields_sql, site[:id]
    fields_rows.each do |field_row|
      field_name = field_row["field_name"].strip
      csv_fields.push field_name
      csv_xpath[field_name] = field_row["xpath"]
    end
    site[:csv_fields] = csv_fields
    site[:xpath] = csv_xpath
    site[:dbh] = dbh
    sites.push site
  end


  require File.dirname(__FILE__)+"/lib/base_parser.rb"
  Dir[File.expand_path(File.dirname(__FILE__)+"/lib/*.rb")].each do |file|
    #include all base classes
    require file
  end

#include all actual page parsers
  Dir[File.expand_path(File.dirname(__FILE__)+"/lib/parsers/*.rb")].each do |file|
    require file
  end

#go through all the sites and launch each of them
  sites.each do |site|
    if site[:active]
      begin
        parser_class = Module.const_get(site[:parser].to_s)

        #some IDEs here will complain that "default constructor has no parameters"
        #disregard -- we use our custom constructors -- they take parameters
        parser = parser_class.new site
        parser.run
      rescue Exception => e
        puts "Unable to start parser: #{e.message}"
      end
    else
      puts "Skipping inactive site: #{site[:title]}"
    end
  end
rescue DBI::DatabaseError => e
  puts "An error occurred"
  puts "Error code: #{e.err}"
  puts "Error message: #{e.errstr}"
ensure
  # disconnect from server
  dbh.disconnect if dbh
end
