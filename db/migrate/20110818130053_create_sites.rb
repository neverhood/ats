class CreateSites < ActiveRecord::Migration
  def self.up
    create_table "sites", :force => true do |t|
      t.string "title", :null => false
      t.string "active", :limit => 1, :default => "y", :null => false
      t.text "url", :null => false
      t.integer "parser_id", :null => false
      t.integer "login_id", :null => true
      t.string "save_html", :limit => 1, :default => "n", :null => false
      t.integer "runs", :default => 0, :null => false
      t.string "status", :default => "idle", :null => false
      t.datetime "last_run"
    end
    add_index "sites", ["id"], :name => "PK", :unique => true
    add_index "sites", ["title"], :name => "site_title", :unique => true
  end

  def self.down
  end
end
