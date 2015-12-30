class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.belongs_to :show
      t.string :track_num
      t.string :title
      t.string :length
      t.string :filename
      t.string :slug
    end
  end
end
