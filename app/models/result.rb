class Result < ActiveRecord::Base
  belongs_to :site
  has_many :result_fields

  PRESELECTED_FIELDS = [:id, :link]

  accepts_nested_attributes_for :result_fields

  attr_accessor :order_direction

  scope :for, lambda { |site| from(site.results_view) }

  def self.fields_as_hash(fields)
    Hash[ fields.map { |field| [field.xpath.id, field.value] } ]
    # ret = {}
    # fields.each do |f|
    #   ret[f.xpath.id] = f.value
    # end
    # return ret
  end

  def to_hash
    Hash[ result_fields.map { |field| [field.xpath.id, field.value] } ]
  end

  #def self.search(params)
  #  cond_string = "1 = 1 "
  #  cond_values=[]
  #  %w{ ref_code html}.each do |f|
  #    unless params[f.to_sym].blank?
  #      cond_string += " AND #{f} LIKE :#{f}"
  #    end
  #  end
  #  if params[:site_id]
  #    cond_string += " AND site_id=:site_id"
  #  end
  #  if params[:time_span] && params[:time_span] != "0"
  #    since = DateTime.now() - params[:time_span].to_i.hours
  #    params[:time_crawled] = since.strftime "%Y-%m-%d %H:%M:%S"
  #    cond_string += " AND time_crawled >= :time_crawled"
  #  end
  #  site = Site.find(params[:site_id])
  #  site.xpaths.each do |x|
  #    cond_string += get_in_sql_for_field(x.available_field.field_name, params) if params[x.available_field.field_name.underscore.to_sym]
  #  end if site
  #  ret = where(cond_string, params).order("time_crawled DESC")
  #  return ret
  #end
  #
  #private
  #def self.get_in_sql_for_field(field_name, params)
  #  ret = nil
  #  field_name = field_name.gsub(/\W/, "")
  #  if(params[field_name.to_sym].nil? || params[field_name.to_sym].empty?)
  #    return ""
  #  end
  #  cond_string= "field_name = '#{field_name}' AND value LIKE :#{field_name}"
  #  fields = ResultField.where(cond_string, params)
  #  if (fields.length > 0)
  #    ret = fields.map { |f| f.result_id.to_s }
  #    ret = ret.join(",")
  #    ret = " AND id IN (#{ret})"
  #  else
  #    ret = " AND ( id IS NULL )"
  #  end
  #  return ret
  #end
end
