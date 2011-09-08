class AddCheckboxesToXpath < ActiveRecord::Migration
  def self.up
    add_column :xpath, :show_in_index, :integer, :default => 1, :null => false
    add_column :xpath, :show_in_full, :integer, :default => 1, :null => false
  end

  def self.down
    remove_column :xpath, :show_in_full
    remove_column :xpath, :show_in_index
  end
end
