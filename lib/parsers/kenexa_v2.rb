require File.dirname(__FILE__) + '/../base_parser'

class Kenexa_v2 < BaseParser

  class << self
    attr_accessor :current_results_page, :total_results_pages
  end

  @current_results_page = 0

  def parse(page)
    super(page)
    form = page.form_with(:id => 'bodyPage:jobSearchForm')

    form.add_field! 'basicShowAllJobs', 'Show all jobs'

    page = form.submit
    Kenexa_v2.current_results_page = 1

    Kenexa_v2.total_results_pages = page.parser.
        xpath("//select[@id='bodyPage:jobSearchResultsForm:JobSearchResultsNavigationPageView:tPagesMenu']").
        text.split('Page').map(&:to_i).max

    @rows_total = $1 if page.parser.
        xpath("//span[@id='bodyPage:jobSearchResultsForm:JobSearchResultsNavigationPageView:jst']") =~ /of\s*(\d+)/i

    details_links = lambda { |page|
      page.links.select { |a| a.attributes['onclick'] =~ /'conversationId'/ }.map {
          |a| a.attributes['id'] }
    }

    clear_dynamic_fields = lambda { |form|
      form.fields.select { |f|
        f.name =~ /bodyPage:jobSearchResultsForm:JobSearchResultsNavigationPageView:searchResultsDataTable/
      }.each { |f|
        form.delete_field! f.name
      }
      form
    }

    next_page = lambda { |current_page|
      if Kenexa_v2.total_results_pages > Kenexa_v2.current_results_page

        form = current_page.form_with(:id => 'bodyPage:jobSearchResultsForm')
        clear_dynamic_fields.call(form)
        form.delete_field! 'conversationPropagation'

        Kenexa_v2.current_results_page += 1

        form['bodyPage:jobSearchResultsForm:JobSearchResultsNavigationPageView:tPagesMenu'] = Kenexa_v2.current_results_page
        form['bodyPage:jobSearchResultsForm:JobSearchResultsNavigationPageView:bPagesMenu'] = Kenexa_v2.current_results_page
        form.submit
      else
        nil
      end
    }

    job_details = lambda { |page, ref_code|
      form = page.form_with(:id => 'bodyPage:jobSearchResultsForm')
      clear_dynamic_fields.call(form)

      form.add_field!(ref_code, ref_code)
      form.add_field!('conversationPropagation', 'begin') if form['conversationPropagation'].nil?
      form.submit
    }

    @done = false

    until @done
      data_links = details_links.call(page)

      data_links.each do |ref_code|
        data_page = job_details.call(page, ref_code)

        log "Opened #{data_page.uri.to_s}"
        fields = get_fields_from_page(data_page)
        save_result_page data_page.uri.to_s, fields
      end

      page = next_page.call(page)
      @done = true unless page
    end

    site_done

  end

end
