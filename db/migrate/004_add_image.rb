class AddImage < ActiveRecord::Migration
  def self.up
    add_column :slides, :image, :binary
  end

  def self.down
    remove_column :slides, :image
  end
end
