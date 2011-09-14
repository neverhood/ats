require File.dirname(__FILE__) + '/../base_parser'

class Kenexa_V1 < BaseParser
  def parse(page)
    m = Mechanize.new
    m.get(page)

    m.page.link_with(:href => /command=CCSearchPage/).click
    form = m.page.forms.last
    form.action = 'CCJobSearchAction.ss?command=CCSearchNow' # Maybe we'll want to populate it someday?

    page = form.submit # No population needed

    details_links = lambda { |page|
      stem = 'CCJobResultsAction.ss?command=ViewJobDetails&job_REQUISITION_NUMBER='
      page.parser.xpath('//td[@class="clsTableItem1"]/a').
        map {|a| (stem + $1) if a['href'] =~ /ID_onClick\('(\d+)'\)/ }
    }

    next_page = lambda { |current_page| 
      form = page.forms.last
      form['PageNumber'] = 5
      form.action = 'CCJobResultsAction.ss?command=MoveToPage'
      page = form.submit
    }

    total_rows = $1.to_i if page.parser.xpath('//td[@class="clsTextbold"]').text =~ /of\s*(\d+)/


#    links = page.parser.xpath('//td[@class="clsTableItem1"]/a')
    # javascript:job_JOB_TITLE_ID_onClick('17327');
    # CCJobResultsAction.ss?command=ViewJobDetails&job_REQUISITION_NUMBER=17327
    links = details_links.call(page)
    puts links

#    form = page.forms.last
#    form.action = links.first
#    page = form.submit


    current_page = page.parser.xpath('//table[@class="pageNo"]/tr/td/font/b')
    puts current_page

#    page = m.get(links.first)
#    puts page.uri.to_s
#    puts page.parser.xpath('//td[@class="clsTableItem1"]')
  end
end
#p = 'https://recruiter.kenexa.com/appleton/cc/CCJobSearchAction.ss?command=CCSearchPage&ccid=bupJEdUjsTs%3D'
p = 'https://recruiter.kenexa.com/dollartree/cc/CCJobSearchAction.ss?command=CCSearchPage&ccid=bupJEdUjsTs%3D'
s = Kenexa_V1.new(p)
s.parse(p)
