class Song < ActiveRecord::Base
  belongs_to :show
  belongs_to :song_group
  has_many :reactions, dependent: :delete_all, class_name: 'Reaction', primary_key: 'id', foreign_key: 'post_id'
  has_many :comments
  has_and_belongs_to_many :playlists
  acts_as_commentable
  validates_uniqueness_of :title, scope: [:show_id, :track_num]
  default_scope { order(track_num: :asc) }
  scope :music, -> {where.not('lower(title) LIKE ? OR lower(title) LIKE ? OR lower(title) LIKE ? OR lower(title) LIKE ? OR lower(title) LIKE ?','%intro%','%tuning%','%crowd%','%banter%','%jam%')}



end
