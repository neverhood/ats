class CreateTableParsers < ActiveRecord::Migration
  def self.up
    create_table "parsers", :force => true do |t|
      t.string "class_name", :null => false
    end

    add_index "parsers", ["id"], :name => "PK", :unique => true


  end

  def self.down
  end
end
