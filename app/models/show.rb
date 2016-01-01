class Show < ActiveRecord::Base
  belongs_to :band
  has_many :songs, dependent: :delete_all

  validates_uniqueness_of :title, scope: :date
end
