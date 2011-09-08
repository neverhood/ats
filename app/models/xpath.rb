class Xpath < ActiveRecord::Base
  set_table_name :xpath
  belongs_to :site, :autosave => true
  belongs_to :available_field
  has_many :result_fields
  validates_presence_of :site_id
  validates_presence_of :available_field_id
  validates_uniqueness_of :available_field_id, :scope=>:site_id
  validates_numericality_of :show_in_index, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  validates_numericality_of :show_in_full, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
  validates_numericality_of :pos

  def self.fields_as_hash(site)
    ret = {}
    site.xpath.each do |x|
      ret[x.id] = x.available_field.field_name
    end
    return ret
  end
end
