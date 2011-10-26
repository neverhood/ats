class Site < ActiveRecord::Base

  belongs_to :parser
  belongs_to :login

  has_many :results, :dependent => :delete_all
  has_many :xpaths, :dependent => :delete_all, :order => :pos

  validates_presence_of :title
  validates_presence_of :status
  validates_presence_of :parser_id

  def self.select_for_copy(site)
    sites = Site.all :conditions=>["id != ? AND parser_id = ?", site.id, site.parser_id]
    ret = sites.map { |j| [j.title, j.id] }
    return ret
  end


  def column_names
    xpaths.in_index.map { |xpath| xpath.available_field.field_name.downcase.
        split(' ').
        join('_').
        to_sym
    } - [:html, :ref_code]
  end

  def default_columns_order
    [:ref_code] + column_names + [:time_crawled]
  end

  def results_view
    # This one was made to simplify the results obtaining process

    available_fields = Hash[
        xpaths.map { |xpath| [ xpath.id, xpath.available_field.field_name.downcase.split(' ').join('_').to_sym ] }.
            reject { |key, value| [:html, :ref_code ].include? value }
    ]

    xpath_ids = xpaths.map(&:id).reject { |xpath_id| !available_fields[xpath_id] }

    sql_mapping_alias = lambda { |xpath_id|
      "`field_#{xpath_ids.index( xpath_id ) + 1}`.`value` AS `#{available_fields[ xpath_id ]}`"
    }

    sql_mapping_join = lambda { |xpath_id|
      field = "`field_#{xpath_ids.index( xpath_id ) + 1}`"
      "inner join `result_fields` AS #{field} ON #{field}.`xpath_id` = #{xpath_id} AND #{field}.`result_id` = `results`.`id`"
    }

    <<VIEW
(SELECT `results`.`ref_code` AS `ref_code`,
`results`.`time_crawled` AS `time_crawled`,
`results`.`link` AS `link`,
`results`.`html` AS `html`,
`results`.`id` AS `id`,
#{ xpath_ids.map { |xpath_id| sql_mapping_alias.call( xpath_id ) }.join(",\n") }
FROM `sites` inner join `results` on `results`.`site_id` = `sites`.`id`
#{ xpath_ids.map { |xpath_id| sql_mapping_join.call( xpath_id ) }.join("\n") }
WHERE `sites`.id = #{self.id}) AS results
VIEW
  end

end
