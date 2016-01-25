class AddBandToSongGroup < ActiveRecord::Migration
  def change
    add_column :song_groups, :band_id, :integer
  end
end
