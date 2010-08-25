class AddImagePath < ActiveRecord::Migration
  def self.up
    add_column :slides, :image_path, :string
  end

  def self.down
    remove_column :slides, :image_path
  end
end
