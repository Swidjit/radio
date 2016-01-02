class Song < ActiveRecord::Base
  belongs_to :show
  belongs_to :song_group
  has_many :reactions, dependent: :delete_all, class_name: 'Reaction', primary_key: 'id', foreign_key: 'post_id'


  validates_uniqueness_of :title, scope: [:show_id, :track_num]
  default_scope { order(track_num: :asc) }
end
