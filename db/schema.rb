# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110903094029) do

  create_table "available_fields", :force => true do |t|
    t.string  "field_name", :null => false
    t.integer "parser_id",  :null => false
  end

  add_index "available_fields", ["field_name", "parser_id"], :name => "field_name", :unique => true
  add_index "available_fields", ["id"], :name => "PK", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "title",                                      :null => false
    t.string   "active",    :limit => 1, :default => "y",    :null => false
    t.text     "url",                                        :null => false
    t.integer  "parser_id",                                  :null => false
    t.integer  "login_id"
    t.string   "save_html", :limit => 1, :default => "y"
    t.integer  "runs",                   :default => 0,      :null => false
    t.string   "status",                 :default => "idle", :null => false
    t.datetime "last_run"
  end

  add_index "sites", ["id"], :name => "PK", :unique => true
  add_index "sites", ["title"], :name => "site_title", :unique => true

  create_table "logins", :force => true do |t|
    t.string "title",    :null => false
    t.string "login",    :null => false
    t.string "password", :null => false
    t.text   "url",      :null => false
  end

  create_table "result_fields", :force => true do |t|
    t.integer "xpath_id",  :null => false
    t.text    "value",     :null => false
    t.integer "result_id", :null => false
  end

  add_index "result_fields", ["id"], :name => "PK", :unique => true
  add_index "result_fields", ["result_id", "xpath_id"], :name => "unique_field_name", :unique => true

  create_table "results", :force => true do |t|
    t.datetime "time_crawled", :null => false
    t.text     "html"
    t.string   "ref_code"
    t.integer  "site_id",       :null => false
    t.text     "link"
  end

  add_index "results", ["id"], :name => "PK", :unique => true

  create_table "parsers", :force => true do |t|
    t.string "class_name",  :null => false
    t.string "title"
    t.text   "description"
  end

  add_index "parsers", ["class_name"], :name => "parser_name", :unique => true
  add_index "parsers", ["id"], :name => "PK", :unique => true

  create_table "xpath", :force => true do |t|
    t.integer "site_id",                                             :null => false
    t.string  "field_name",                                         :null => false
    t.text    "xpath",         :limit => 2147483647,                :null => false
    t.string  "delimiter"
    t.integer "show_in_index",                       :default => 1, :null => false
    t.integer "show_in_full",                        :default => 1, :null => false
    t.integer "pos",                                 :default => 0, :null => false
  end

  add_index "xpath", ["site_id", "field_name"], :name => "unique_field_name", :unique => true

end
