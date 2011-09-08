class AddPosToXpath < ActiveRecord::Migration
  def self.up
    add_column :xpath, :pos, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :xpath, :pos
  end
end
