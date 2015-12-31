class SongGroup < ActiveRecord::Base
  has_many :songs
  acts_as_commentable
end
