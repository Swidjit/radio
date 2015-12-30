class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name, :default=>:false
      t.string :description
      t.integer :show_count
      t.integer :song_count
      t.string :slug
    end
  end
end
