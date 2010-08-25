class AddTypeToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :sequence, :string
  end

  def self.down
    remove_column :slides, :sequence
  end
end
