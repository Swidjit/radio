class CreateSongGroups < ActiveRecord::Migration
  def change
    create_table :song_groups do |t|
      t.string :title
      t.integer :count, :default=>0
      t.integer :importance, :default=>0
      t.integer :ranking, :default=>0
      t.string :start_date
      t.string :end_date

    end

    add_column :songs, :song_group_id, :integer
  end
end
