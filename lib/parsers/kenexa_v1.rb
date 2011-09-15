require File.dirname(__FILE__) + '/../base_parser'

class Kenexa_v1 < BaseParser
  def parse(page)

    super(page)

    actions = { 
      :search => 'CCJobSearchAction.ss?command=CCSearchNow',
      :view_job_details => 'CCJobResultsAction.ss?command=ViewJobDetails&job_REQUISITION_NUMBER=',
      :move_to_page => 'CCJobResultsAction.ss?command=MoveToPage'
    }

    @agent.page.link_with(:href => /command=CCSearchPage/).click # Site complains that session has expired. refresh

    form = @agent.page.forms.last
    form.action = actions[:search]

    page = form.submit # No population needed

    details_links_ref_codes = lambda { |page| 
      page.parser.xpath('//td[@class="clsTableItem1"]/a').
        map { |a| $1 if a['href'] =~ /ID_onClick\('(\d+)'\)/ }
    }

    next_page = lambda { |current_page| 
      current_page = page.parser.xpath('//table[@class="pageNo"]/tr/td/font/b').text.to_i
      form = page.forms.last
      form['PageNumber'] = current_page + 1
      form.action = actions[:move_to_page]
      form.submit
    }

    view_job_details = lambda { |ref_code| 
      form = page.forms.last
      form['job_REQUISITION_NUMBER'] = ref_code
      form.action = actions[:view_job_details] + ref_code
      form.submit
    }

    @rows_total = $1.to_i if page.parser.xpath('//td[@class="clsTextbold"]').text =~ /of\s*(\d+)/

    while @rows_parsed.to_i < @rows_total
      ref_codes = details_links_ref_codes.call(page)

      ref_codes.each do |ref_code|
        data_page = view_job_details.call(ref_code)

        log "Opened #{data_page.uri.to_s}"
        fields = get_fields_from_page(data_page)
        save_result_page data_page.uri.to_s, fields
      end

      page = next_page.call(page)
    end

    site_done
  end
end
