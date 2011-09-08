class CreateLogins < ActiveRecord::Migration
  def self.up
    create_table "logins", :force => true do |t|
      t.string "title", :null => false
      t.string "login", :null => false
      t.string "password", :null => false
      t.text "url", :null => false
    end
  end

  def self.down
  end
end
