class AvailableField < ActiveRecord::Base
  belongs_to :parser
  has_many :xpaths
  validates_presence_of :field_name
  validates_presence_of :parser_id
  validates_uniqueness_of :field_name, :scope => :parser_id

  def self.for_options(parser)
    AvailableField.where(["parser_id = ?", parser.id]).map { |f| next [f.field_name, f.id] }
  end
end
