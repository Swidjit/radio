class SongGroup < ActiveRecord::Base
  has_many :songs
  has_many :song_votes
  belongs_to :band
  acts_as_commentable
  scope :music, -> {where.not('lower(title) LIKE ? OR lower(title) LIKE ? OR lower(title) LIKE ? OR lower(title) LIKE ? OR lower(title) LIKE ?','%intro%','%tuning%','%crowd%','%banter%','%jam%')}

end
