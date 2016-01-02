class Reaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :show,class_name: 'Show', foreign_key: 'post_id'
  belongs_to :song,class_name: 'Song', foreign_key: 'post_id'

  validates_presence_of :post_id, :user, :reaction_type

  scope :loved, lambda{ where("#{table_name}.reaction_type = ?","love")}
  scope :liked, lambda{ where("#{table_name}.reaction_type = ?","like")}
  scope :shared, lambda{ where("#{table_name}.reaction_type = ?","share")}
  scope :off_topic, lambda{ where("#{table_name}.reaction_type = ?","off-topic")}
  scope :offensive, lambda{ where("#{table_name}.reaction_type = ?","offensive")}

  after_create :notify

  def notify
  end
end
