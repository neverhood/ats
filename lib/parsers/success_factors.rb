require File.dirname(__FILE__) + '/../base_parser'

class SuccessFactors < BaseParser
  #
  class << self  # We`re about to declare some templates within an instance variable since we'll change some values
    attr_accessor :data_sets, :current_results_page, :actions
  end

  @data_sets = {
      :search => {"navBarLevel"=>"JOB_SEARCH", "customFilter_filter5"=>nil, "fbcs_postedwithindays"=>nil,
                  "career_job_req_id"=>nil, "referral_key"=>nil, "jobPipeline"=>nil,
                  "customFilter_filter6"=>nil, "isExternal"=>"true",
                  "fbcs_keyword"=>nil, "customFilter_filter1"=>nil, "fbcs_reqnum"=>nil, "career_os"=>"home",
                  "customFilter_filter2"=>nil, "career_ns"=>"job_listing_summary", "career_company"=>"Avnet"},
      :view_job_details => {"mailjob_friend_email"=>nil, "navBarLevel"=>nil, "career_job_req_id"=>nil, "referral_key"=>nil, "jobPipeline"=>nil,
                            "isExternal"=>"true", "mailjob_user_email"=>nil, "jlsummary_pSize"=>"10", "jlsummary_PRid"=>"1",
                            "ps_defaultPaginationBean"=>"10", "mailjob_message"=>nil, "fbja_delete_draft"=>nil, "jlsummary_sort_col"=>"0",
                            "career_job_app_sec_key"=>nil, "fbja_appId"=>nil, "fbacme_n"=>nil, "selected_lang"=>nil, "career_os"=>"home",
                            "ri_defaultPaginationBean"=>"1", "mailjob_user_captcha_value"=>nil, "isRecruitEvent"=>"false",
                            "career_ns"=>"job_listing", "career_company"=>"Avnet", "jlsummary_sort_dir"=>"0",
                            "nps_defaultPaginationBean"=>"10", "mailjob_captcha_value"=>"hhCBsfnSifM%3D"},
      :switch_page => {"mailjob_friend_email"=>nil, "navBarLevel"=>nil, "career_job_req_id"=>nil, "referral_key"=>nil, "jobPipeline"=>nil,
                       "isExternal"=>"true", "mailjob_user_email"=>nil, "jlsummary_PRid"=>"11", "jlsummary_pSize"=>"10", "ps_defaultPaginationBean"=>"10",
                       "mailjob_message"=>nil, "fbja_delete_draft"=>nil, "jlsummary_sort_col"=>"0", "career_job_app_sec_key"=>nil,
                       "fbja_appId"=>nil, "fbacme_n"=>nil, "career_os"=>"home", "selected_lang"=>nil, "ri_defaultPaginationBean"=>"11",
                       "mailjob_user_captcha_value"=>nil, "isRecruitEvent"=>"false", "career_ns"=>"job_listing_summary",
                       "career_company"=>"Avnet", "jlsummary_sort_dir"=>"0", "nps_defaultPaginationBean"=>"10",
                       "mailjob_captcha_value"=>"a0qTeZRMYko%3D"
      }
  }
  @actions = {
      :search => '',
      :view => '',
      :switch_page => ''
  }
  @current_results_page = 1


  def self.set_pagination_start(number)
    self.data_sets[:switch_page]['ri_defaultPaginationBean'] = number
  end

  def self.set_company_name(company)
    self.data_sets[:search]['career_company'] = company
    self.data_sets.keys.each { |key| self.data_sets[key]['career_company'] = company }
  end

  # The SuccessFactors sites series is a complete shi**y javascript mess.
  # Dealing with forms is too unreliable, we`ll use regular POST requests instead

  def parse(page)
    super(page)

    form = page.form_with(:id => 'careerform')
    company = page.parser.xpath('//input[@id="career_company"]').first['value']

    SuccessFactors.set_company_name(company)


    get_details_page = lambda { |page,ref_code|
      SuccessFactors.data_sets[:view_job_details]['career_job_req_id'] = ref_code
      @agent.post(page.forms.first.action, SuccessFactors.data_sets[:view_job_details])
    }

    details_links = lambda { |page|
      page.links.select { |link| link.href =~ /career_job_req_id/ }.
          map { |link| $1 if link.href =~ /setField\('.*', '(\d+)'\)/  }
    }

    switch_results_page = lambda { |page|
      SuccessFactors.set_pagination_start(SuccessFactors.current_results_page*10 + 1)
      @agent.post(SuccessFactors.actions[:view], SuccessFactors.data_sets[:switch_page])
      if details_links.call(@agent.page).length > 0
        @agent.page
      else
        nil
      end
    }

    if form
      page = @agent.post(form.action, SuccessFactors.data_sets[:search])
      SuccessFactors.actions[:view] = page.forms.first.action
    end

    @rows_total = $1.gsub(',', '').to_i if page.parser.xpath("//div[@class='content']/div[@class='pagination_row'][1]/div[@class='pagination_top']/div").text.strip =~ /.*of\s*([\d,]+)/m
    @done = false

    until @done
      details_links.call(page).each do |details_link|
        details_page = get_details_page.call(page, details_link)

        log "Opened '#{details_page.uri.to_s}'"

        fields = get_fields_from_page(details_page)
        fields[:ref_code] = details_link unless fields[:ref_code]
        save_result_page details_page.uri.to_s, fields
      end

      page = switch_results_page.call(page)
      @done = true if page.nil?
      SuccessFactors.current_results_page += 1
    end

    site_done

  end

end


