class SongVote < ActiveRecord::Base
  belongs_to :song_group
  belongs_to :user

  after_save :update_popularity

  def update_popularity
    self.song_group.increment!(:importance, self.frequency)
  end
end
