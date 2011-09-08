class AddTitleAndDescriptionColumnsToParsers < ActiveRecord::Migration
  def self.up
    add_column :parsers, :title, :string
    add_column :parsers, :description, :text
    add_index "parsers", ["title"], :name => "parser_title", :unique => true
  end

  def self.down
    remove_column :parsers, :description
    remove_column :parsers, :title
  end
end
