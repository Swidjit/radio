class AddCommentCountToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :comment_count, :integer
  end
end
