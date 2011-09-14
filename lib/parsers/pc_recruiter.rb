require File.dirname(__FILE__) + "/../base_parser"

class PCRecruiter < BaseParser

  def parse(page)

    super(page)
    form = page.form_with :id => 'mainsearch'

    page = form.submit
    @rows_total = $1.to_i if page.parser.xpath('//td[@id="reg5_td4"]').inner_text =~ /.*of\s*(\d+).*/

    log "Found #{@rows_total}"

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
        #rows_parsed += 1
      end

      form = page.form_with(:id => 'more2')
      page = form.submit if form # No form on last page

    end

    site_done
  end

end

#p = 'http://www.pcrecruiter.net/pcrbin/regmenu.exe?uid=extendicare%20health%20services.extendicarehealthservices'
#p = 'http://www.pcrecruiter.net/pcrbin/regmenu.exe?i1=PUBLIC&i2=&i3=CHECK&i4=+&i5=&i6=PUBLIC&i7=&i8=9%2f14%2f2011%208:34:29%20AM&i9=&i10=&pcr-id=Wd414KX%2f9Qqs%2fgTG55YCNVnGexGpigNapyZiWgO05G330oInKQws0A6WdIWwMKtIMyrbnOaOUN1S%0D%0AE3MlEfLbpFau%2bI0ya8M%3d'
#s = PCRecruiter.new('site :)')
#s.parse(p)
