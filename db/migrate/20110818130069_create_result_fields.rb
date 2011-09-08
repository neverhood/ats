class CreateResultFields < ActiveRecord::Migration
  def self.up
    create_table "result_fields", :force => true do |t|
      t.integer "xpath_id", :null => false
      t.text "value", :null => false
      t.integer "result_id", :null=>false
    end
    add_index "result_fields", ["id"], :name => "PK", :unique => true
    add_index "result_fields", ["result_id", "xpath_id"], :name=>"unique_field", :unique => true
  end

  def self.down
  end
end
