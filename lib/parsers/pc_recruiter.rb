require File.dirname(__FILE__) + "/../base_parser"

class PCRecruiter < BaseParser

  def parse(page)

    super(page)
    form = page.form_with :id => 'mainsearch'

    page = form.submit
    @rows_total = $1.to_i if page.parser.xpath('//td[@id="reg5_td4"]').inner_text =~ /.*of\s*(\d+).*/

    log "Found #{@rows_total} results"

    details_links = lambda { |page| 
      page.parser.xpath('//td[contains(@class, "reg5_col_title")]/span/a').
        map { |a| a['href'] }
    }

    while @rows_parsed.to_i < @rows_total
      # current page: puts page.parser.xpath('//span[@class="pcrpagex"]').inner_text
      links = details_links.call(page)

      links.each do |link|
        data_page = @agent.get(link)
        log "Opened '#{data_page.uri.to_s}'"

        fields = get_fields_from_page(data_page)
        fields[:ref_code] = $1 if link =~ /.*hash=(\d+)/ # No idea where is the actual REF_CODE
        save_result_page data_page.uri.to_s, fields
      end

      form = page.form_with(:id => 'more2')
      page = form.submit if form # No form on the last page

    end

    site_done
  end

end
