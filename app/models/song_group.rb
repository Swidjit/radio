class SongGroup < ActiveRecord::Base
  has_many :songs
  has_many :song_votes
  acts_as_commentable
end
