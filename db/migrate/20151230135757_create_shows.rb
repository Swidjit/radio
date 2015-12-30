class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.belongs_to :band
      t.string :title
      t.datetime :date
      t.string :year
      t.string :description
      t.string :identifier
      t.string :slug
    end
  end
end
