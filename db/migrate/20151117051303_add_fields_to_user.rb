class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, :null=>:false
    add_column :users, :first_name, :string
    add_column :users, :about, :text
  end
end