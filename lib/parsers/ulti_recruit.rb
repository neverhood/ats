require File.dirname(__FILE__)+"/../base_parser"
class UltiRecruit < BaseParser
  def parse(page)
    # Always invoke this method at the beginning (or very near).
    # In future it will perform some useful stuff (benchmarking etc)
    super page
    #Find "search form and submit it"
    form = page.form_with :id=>"PXForm"
    #In some cases you should forge some values like "date range" etc
    #Use FireBug and/or Fiddler2 to figure out proper GET/POST parameters
    page = form.submit

    #So, here 'page' contains page with list of links to "details page"
    #and some more nice stuff like total results found:
    @rows_total = page.parser.xpath('//form[@id="PXForm"]/table/tr/td/span[5]').text
    log "Found #{@rows_total}"

    #Have you noticed @rows_parsed and @rows_total?
    #They originate from BaseParser, please use them
    while @rows_parsed.to_i < @rows_total.to_i
      #Lets get all links leading to "details pages":
      links =page.parser.xpath '//form[@id="PXForm"]/table[2]/tr/td[1]/a'

      #It appears that the 1st link is "Set Order" link/button found in table's header row
      if links.size > 0
        links= links[1, links.size - 1] #remove link which appears to be header column title
      end
      #Now we can parse through the links to "detail pages"
      links.each do |details_link|
        data_page = @agent.get details_link.attr "href"
        log "Opened '#{data_page.uri.to_s}'"

        #Lets get data structure suitable to create Result and nested ResultField
        #See BaseParser for this method
        fields = get_fields_from_page data_page

        #And save it
        #See BaseParser for this method
        save_result_page data_page.uri.to_s, fields
      end
      # open next page
      # by "next page" I mean those [1][2]...[N] in the pager
      # So this is "next page with results links"
      # In our case it is [>] button in the form
      form = page.form_with :id=>"PXForm"
      form["__Next"] = ">"
      page = form.submit
    end
    #Always invoke this method after you've done with parsing!
    #See BaseParser
    site_done
  end
end