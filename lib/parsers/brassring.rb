require File.dirname(__FILE__)+"/../base_parser"
class Brassring < BaseParser
  def parse(page)
    super page
    search_form = page.form_with :name=>"frmAgent"
    resuts_page = search_form.submit
    total_entries = resuts_page.parser.xpath('//*[@id="PagingTable"]/tr[2]/td[2]').text

    if total_entries =~ /(\d+)\s*$/
      total_entries = $1
    else
      total_entries = "unknown"
    end
    start_res_idx = 1
    while true
      log "Found #{total_entries} entries"
      detail_links = resuts_page.parser.xpath('//*[@id="MainTable"]/tr/td/a')
      detail_links.each do |d_link|
        if d_link.attribute("class")
          next
        else
          data_page = @agent.get d_link.attribute("href")
          fields = get_fields_from_page data_page
          save_result_page page.uri.to_s, fields
          #break
        end
      end
      start_res_idx += 50
      break if start_res_idx > total_entries.to_i
      next_page_form = resuts_page.form_with(:name=>"frmMassSelect")
      next_page_form["recordstart"] = start_res_idx.to_s
      resuts_page = next_page_form.submit
    end
    site_done

  rescue Exception => e
    log "error: #{e}"
  end
end