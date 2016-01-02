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
  after_save :propagate_importance

  def notify
  end

  def propagate_importance
    puts self.reaction_source
    if self.reaction_source == 'song'
      puts self.post_id
      song = Song.find(self.post_id).song_group
      puts song
      case self.reaction_type
        when 'like'
        song.increment!(:importance, 1)
        when 'love'
        song.increment!(:importance, 3)
        when 'share'
        song.increment!(:importance, 5)
      end
    end
  end
end
