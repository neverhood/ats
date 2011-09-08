require File.dirname(__FILE__)+"/irc_parser"
class OracleIrecruitment_v1 < IRCParser


  def parse(page)

    super page

    #search form
    form = page.forms[0]

    #find search button
    options = page.parser.xpath '//*[@id="Search"]'


    #add fields found in onclick attribute from the search button to the form
    #stupid Oracle every click on any link converts to entire form to be submit...
    decorate_form form, options

    form.field_with(:name =>"DatePosted2").options.last.select
    list_page = form.submit
    next_form_node = list_page.parser.xpath("//form").pop
    #here we save our own generated copy of form
    next_form = Mechanize::Form.new next_form_node, @agent
    page_number =1
    while true do
      log "Page: #{page_number}"
      link_form = list_page.forms[0].clone
      result_links = list_page.parser.xpath('//a[starts-with(@id, "JobSearchTable:JobName")]')

      log "found #{result_links.length} site links..."

      break if result_links.length < 1
      result_links.each do |result_link|
        decorate_form link_form, result_link
        data_page = link_form.submit
        fields = get_fields_from_page data_page
        fields[:ref_code] = utf8(result_link.text.gsub(/\./, ""))
        save_result_page page.uri.to_s, fields
        #break
      end

      next_link = list_page.parser.css 'span#JobSearchTable table tr td table.x1i tr td table tr td a.x41'
      break if next_link.nil? || (page_number > 1 && next_link.length < 2)
      log "opening next page"
      next_link = next_link.pop
      prepare_next_link_options(next_link)

      decorate_form(next_form, next_link)
      #for some reason this fields gets changed
      #lets force it to empty value
      act = next_form.field_with(:name=>"IrcAction")
      act.value = ""
      list_page = next_form.submit
      page_number +=1
    end
    site_done

  rescue Exception => e
    log "error: #{e}"
  end
end