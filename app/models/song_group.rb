class SongGroup < ActiveRecord::Base
  has_many :songs
  has_many :song_votes
  belongs_to :band
  acts_as_commentable
end
