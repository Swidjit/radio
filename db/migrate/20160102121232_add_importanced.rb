class AddImportanced < ActiveRecord::Migration
  def change
    add_column :songs, :importance, :integer, :default=>0
    add_column :shows, :importance, :integer, :default=>0
  end
end
