class Parser < ActiveRecord::Base
  has_many :sites
  has_many :available_fields, :dependent => :delete_all
  validates_presence_of :class_name
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_uniqueness_of :class_name

  def self.for_select
    Parser.all.map { |w| [w.title, w.id] }
  end

  def self.select_for_copy(parser)
    parsers = Parser.all :conditions=>["id != ?", parser.id]
    ret = parsers.map do |parser|
      if parser.available_fields.count > 0
        [parser.title, parser.id]
      end
    end
    return ret
  end
end
