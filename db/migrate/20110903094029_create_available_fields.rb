class CreateAvailableFields < ActiveRecord::Migration
  def self.up
    create_table "available_fields", :force => true do |t|
      t.string "field_name", :null => false
      t.integer "parser_id", :null => false
    end

    add_index "available_fields", ["id"], :name => "PK", :unique => true
    add_index "available_fields", ["field_name", "parser_id"], :name => "field_name", :unique => true
  end

  def self.down
  end
end
