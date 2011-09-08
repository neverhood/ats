class CreateXpaths < ActiveRecord::Migration
  def self.up
    create_table "xpath", :force => true do |t|
      t.integer "site_id", :null => false
      t.integer "available_field_id", :null => false
      t.text "xpath", :limit => 2147483647, :null => false
      t.string "delimiter"
    end
    add_index "xpath", ["site_id", "available_field_id"], :name => "unique_field_name", :unique => true

  end

  def self.down
  end
end
