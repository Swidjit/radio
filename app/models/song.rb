class Song < ActiveRecord::Base
  belongs_to :show
  belongs_to :song_group
  acts_as_commentable
end
