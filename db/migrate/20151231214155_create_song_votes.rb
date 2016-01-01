class CreateSongVotes < ActiveRecord::Migration
  def change
    create_table :song_votes do |t|
      t.belongs_to :song_group
      t.belongs_to :user
      t.integer :frequency
      t.timestamps
    end
  end
end
