require File.dirname(__FILE__)+"/irc_parser"
class OracleIrecruitment_v2 < IRCParser
  def parse(page)

    super page

    #search form
    form = page.forms[0]

    #find search button
    options = page.parser.xpath '//*[@id="Go"]'

    #add fields found in onclick attribute from the search button to the form
    #stupid Oracle every click on any link converts to entire form to be submit...
    decorate_form form, options

    #this will not work with newer version, however you can experiment
    #keep in mind:
    #1) this can be crypted like 180S#d54Ss
    #2) if not crypted -- server checks for valid value and returns error 500 should it not accept yours
    #form.field_with(:name =>"DatePosted2").value= "180"

    #the best way: choose the latest option in the DateSelect field -- crypted or not -- it will be acepted
    form.field_with(:name =>"DatePosted2").options.last.select

    #result now contain page with links to the site-posting
    list_page = form.submit

    #page number -- to be output to terminal window
    page_number =1

    #count of parsed/saved site-postings
    parsed_count=0
    while true do #this will break on complex condition(s) below
      log "Page: #{page_number}"
      link_form = list_page.forms[0].clone #clone is needed because of way Mechanize/Nokogiry handles forms
      next_form = list_page.forms[0].clone

      #array of site links on the page
      result_links = list_page.parser.xpath('//a[starts-with(@id, "JobSearchTable:JobName")]')

      #log sites count
      log "found #{result_links.length} site links..."

      #break if we have opened a page, but it is empty
      break if result_links.length < 1

      #go through the result links list
      result_links.each do |result_link|

        #since oracle submits form for each link,
        #parse link, take it onclick attribute and add it to the form
        decorate_form link_form, result_link

        #get detailed page with site posting
        data_page = link_form.submit
        fields = get_fields_from_page data_page
        fields[:ref_code] = utf8(result_link.text.gsub(/\./, ""))
        save_result_page page.uri.to_s, fields
        #break
      end


      #open next page

      #attention! this is an array of prev/next links
      #it contains 1 element on first (next) and last (prev) pages
      #or no elements if there is one and only page with site links
      next_link = list_page.parser.css 'span#JobSearchTable table tr td table.x1i tr td table tr td a.x41'

      #check if just parsed the last page
      break if next_link.nil? || (page_number > 1 && next_link.length < 2)
      log "opening next page"
      next_link = next_link.pop #if not last page we have 2 links with the same

      #same thing as before -- convert onclick attribute to form fields
      prepare_next_link_options(next_link)
      decorate_form(form, next_link)

      #open the next page
      list_page = form.submit
      page_number +=1
    end
    site_done

  rescue Exception => e
    log "error: #{e}"
  end
end