class Song < ActiveRecord::Base
  belongs_to :show
  acts_as_commentable
end
