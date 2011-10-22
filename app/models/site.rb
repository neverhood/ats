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
    }
  end

  def default_columns_order
    [:ref_code] + column_names + [:crawled_time]
  end

end
