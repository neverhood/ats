class CreateResults < ActiveRecord::Migration
  def self.up
    create_table "results", :force => true do |t|
      t.datetime "time_crawled", :null => false
      t.text "link", :null => false
      t.text "html"
      t.string "ref_code"
      t.integer "site_id", :null => false
    end
    add_index "results", ["id"], :name => "PK", :unique => true
  end

  def self.down
  end
end
