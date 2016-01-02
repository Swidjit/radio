class Show < ActiveRecord::Base
  belongs_to :band
  has_many :songs, dependent: :delete_all
  has_many :reactions, dependent: :delete_all, class_name: 'Reaction', primary_key: 'id', foreign_key: 'post_id'
  has_many :productos


  validates_uniqueness_of :title, scope: :date
end
