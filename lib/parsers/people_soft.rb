require File.dirname(__FILE__)+"/ats_parser"
class PeopleSoft < ATSParser
  def parse(page) 
    super

    page = page.frames.last.click if page.frames.length > 0
    search_form = page.form_with :name=>"win0"
    decorate_form search_form, "HRS_APP_SRCHDRV_HRS_SEARCH_BTN"
    search_form["HRS_APP_SRCHDRV_HRS_POSTED_WTN"]="A"

    resuts_page = search_form.submit

    total_entries = resuts_page.parser.xpath("//span[@class=\"PABOLDTEXT\"]").first.text

    total_entries =~ /(\d+)/
    total_entries = $1
    parsed_count = 0
    set_site_status "found #{total_entries} results"
    while true #pager
      link_form = resuts_page.form_with :name=>"win0"
      #links to details 10 per page
      (0..9).each do |link_idx|
        link_id = "SCH_Site_TITLE_LINK$#{link_idx}"
        if resuts_page.parser.xpath("//*[@id=\"#{link_id}\"]").empty?
          break
        end
        decorate_form link_form, link_id
        details_page = link_form.submit
        csv_row = save_result_page details_page, "n/a"
        @rows.push csv_row
        plain_data = details_page.parser.xpath "//*[@id=\"ACE_width\"]"
        parsed_count += 1
        save_page csv_row.get("ref_code"), plain_data, "n/a", "#{parsed_count} of #{total_entries}"
      end
      nextpage_link = resuts_page.parser.xpath("//@id=\"HRS_SCH_WRK_HRS_LST_NEXT\"")
      break if parsed_count >= total_entries.to_i || !nextpage_link
      decorate_form link_form, "HRS_SCH_WRK_HRS_LST_NEXT"
      # decorate_form link_form, "HRS_SCH_WRK_HRS_LAST_LIST"
      resuts_page = link_form.submit
    end
    set_site_status "idle"
    update_run_counter
  rescue Exception=>e
    set_site_status "error: #{e}"
  end

  def decorate_form(form, action)
    @resubmit = 0 unless @resubmit
    form["ICAction"]=action
    form["ICResubmit"]= "0" #@resubmit.to_s
    @resubmit +=1

    form["ICXPos"]="0"
    form["ICYPos"]="530"
  end

  def save_page(file_name, data, link, parsed_count)
    if @site[:save_html]== "y" || @site[:save_html]== "Y"
      data = simplify_html file_name, data, link
    else
      data=""
    end
    row = @rows.pop
    row.set "html", data
    save_row_to_db row, parsed_count
  end

  def save_data
    #we do not save into file
  end
end