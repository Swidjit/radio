class ModifyTrackNumType < ActiveRecord::Migration
  def change
    remove_column :songs, :track_num
    add_column :songs, :track_num, :integer
  end
end
