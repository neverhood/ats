#Base class for all parsers
#Parser is someone who does the site
#sites are described in ats.rb file

require 'rubygems'
require 'mechanize'
require 'mechanize/form'
require 'ftools'

class BaseParser

  #initializes a parser
  #sets some default Mechanize.agent parameters
  def initialize(site)
    @site = site
    @agent = Mechanize.new
    @agent.user_agent = Mechanize::AGENT_ALIASES['Windows Mozilla']
    @agent.follow_meta_refresh = true
    @agent.history.max_size=10

    @agent.open_timeout = 100000 #sometimes even this huge timeout is not enough...
    @rows_parsed = 0
    @rows_total = 0

    @utf8_converter = Iconv.new('UTF-8//IGNORE', 'UTF-8')
  rescue Exception => e
    log "Unable to login: #{e.message}"
  end

  #Adds fields to Mechanize::Form
  #mainly used for login forms
  def add_fields_to_form(form, fields)
    fields.each do |f|
      form.add_field!(f[:name], f[:value])
    end
  end

  #opens URL given in site's configurations (see model Site)
  #calls parse method of its subclass
  def run
    log "Parsing..."
    url = "unknown"
    if @site.url
      url = @site.url
      log "Opening #{url} as a data page"

      #get page according to URL what was setup in ats.rb
      @page = @agent.get(url)

      #parse method should be override in subclasses
      @data = parse(@page)
    else
      #some sites do not have "datapage" URL
      #for example after login you're already on your very own datapage
      #this is to be addressed in 'parse' method of subclass
      @data = parse(nil)
    end


  rescue Exception=>e
    puts "Failed to parse URL '#{url}', exception=>"+e.message
    set_site_status("error "+e.message)
  end

  #this must be overriden in subclasses
  #actually a subclass can call super()
  def parse(page)
    #In future we will add some useful logic here
    #so, -- please call  super(page) as a first row of your parse() method
  end

  #replace different HTML enteties and tags to sybols which mean/look the same
  #but have nice look in CSV/Excel files
  def html2text(data)
    data.gsub! "\n", ""
    #data.gsub! /\xA0/u, " "
    #data.gsub! /\xC2/u, " "
    data.gsub! "\r", ""
    data.gsub! /<br>/, "\n"
    data.gsub! /<\/p>/, "\n"
    data.gsub! /<\/div>/, "\n"
    data.gsub! /<ul[^>]*>/, "\n"
    data.gsub! /<li[^>]*>/, "\x95 "
    data.gsub! /<\/li>/, "\n"
    data.gsub! /<\/?\??\w+[^>]*>/, ""
    data.gsub! /[ ]{2,}/, " "
    data.gsub! /(\s?\n\s?){2,}/, "\n"
    data.strip!
    return data
  end


  #This is used to store HTML in simplified form
  #removes all unsuitable tags
  def simplify_html(data)
    data=data.to_s
    data.gsub! /<img[^<]*>/, ""
    data.gsub! /<input[^<]*>/, ""
    data.gsub! /<textarea[^<]*>/, ""
    data.gsub! /<form[^<]*>/, ""
    data.gsub! /<select[^<]*>/, ""
    data = "<html><head>\n<meta content=\"text/html; charset=utf-8\" http-equiv=\"Content-Type\">\n</head>\n<body>\n"+data+"\n</body>\n</html>"
    return data
  end


  #Saves a result
  #this is invoked when you have opened data (AKA "details") page and parsed fields from there using (see get_fields_from_page())
  #URL is adress of the "details" page
  #result params is hash using which Result.create will create a Result with nested ResultField objects
  #just like if you would send it from a form:
  # result{
  # :ref_code => "PAGE ID, as it is found on the crawled site",
  # :html => "simplified html"
  # :result_fields_attributes => [
  #    {
  #     :xpath_id => "ID of XPath which has returned this field"
  #     :value => "Data from the site, returned by corresponding XPath"
  #     }, ...
  # ]
  #}
  def save_result_page(url, result_params)
    result = Result.find_by_sql(["select * from results where site_id = ? AND ref_code = ?", @site.id, utf8(result_params[:ref_code])]).first
    #delete fields with data (ResultField) if result with given ref_code is found
    unless result.nil?
      result.result_fields.each do |f|
        f.delete
      end
      result.link = url
      result.time_crawled = DateTime.now().strftime "%Y-%m-%d %H:%M:%S"
      result.html = result_params[:html]
      fields = []
      result_params[:result_fields_attributes].each do |f|
        fields.push ResultField.new(f)
      end
      result.result_fields = fields
      result.save
    else
      #Or create new Result
      result_params[:site_id] = @site.id
      result_params[:time_crawled] = DateTime.now().strftime "%Y-%m-%d %H:%M:%S"
      result_params[:link] = url
      result = Result.create result_params
    end
    @rows_parsed +=1
    msg = "Saved #{@rows_parsed}"
    msg +=" of #{@rows_total}" if @rows_total.to_i > 0
    log msg
    return result
  end

  # Take @site (Site), go through each of associated xpathes and try to retrieve data from the page corresponding
  # to the xpath
  # Sometimes one would want to combine several zones of the page, identified by different XPathes into one field
  # For example: There is field "Location" for given parser. The location consists of "country", "state", "city"
  # units which are located at different XPathes ('//table[@id="location"]/tr[1]/td[2]', '//table[@id="location"]/tr[2]/td[2]', //table[@id="location"]/tr[3]/td[2])
  # This is achieved by entering all 3 XPathes into 'xpath' property if Xpath model, having separated them with an empty line

  def get_fields_from_page(page)
    ref_code = nil
    result = {}
    fields = []
    @site.xpaths.each do |xpath|
      field_name = xpath.available_field.field_name
      value = ""
      values=[]
      # parts are those "multiple xpathes separated by empty line" described in this method header comment
      # each is processed and then added to values[] which will be later joined with "delimiter"
      parts = xpath.xpath.split(/^\s*$/)
      delimiter = xpath.delimiter || ""
      parts.each do |part|
        unless part.strip.empty?
          val_html = page.parser.xpath(part.strip).inner_html
          val_html = html2text(val_html) unless  field_name.casecmp("html") == 0
          values.push(val_html)
        end
      end
      #for some reason there were a lot of MySQL errors before utf8() came onto stage
      value =utf8(values.join delimiter)
      #html and ref_code fields are special -- they are stored in Result model, all the rest -- ResultField
      if  field_name.casecmp("html") == 0
        if @site.save_html.casecmp("y") == 0
          value = simplify_html(value)
          result[:html] = value
        end
      elsif  field_name.casecmp("ref_code") == 0
        ref_code = value
        result[:ref_code] = value
      else
        fields.push({:xpath_id => xpath.id, :value=> value})
      end

    end
    result[:result_fields_attributes] = fields
    return result

  end


  #sets Site status and saves the site
  #Site status is limited to 256 characters
  def set_site_status(status)
    status = status[0, 255] if status.length > 255
    @site.status = utf8(status)
    @site.save
  end

  #updates site-s runs and last_run fields
  def update_run_counter
    now = DateTime.now().strftime "%Y-%m-%d %H:%M:%S"
    @site.runs +=1
    @site.last_run = now
    @site.save
  end

  #This is to be used when parsing is done
  #sets default site status (idle) and updates site's run counter
  def site_done
    set_site_status "idle"
    update_run_counter
  end

  #output to terminal screen, sets site's status
  #in future version can make some smart formatting etc
  def log(what)
    set_site_status what
    puts what
  end

  #Ensure valid UTF-8
  #Mainly came into existence due to MySQL complains "value for NNN contains wrong character"
  def utf8(untrusted_string)
    valid_string = @utf8_converter.iconv(untrusted_string + ' ')[0..-2]
    return valid_string
  end
end