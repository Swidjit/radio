class Song < ActiveRecord::Base
  belongs_to :show
  belongs_to :song_group
  acts_as_commentable
  validates_uniqueness_of :title, scope: [:show_id, :track_num]
  default_scope { order(track_num: :asc) }
end
