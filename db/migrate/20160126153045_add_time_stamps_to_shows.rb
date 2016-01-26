class AddTimeStampsToShows < ActiveRecord::Migration
  def change
    add_column :shows, :created_at, :datetime
    add_column :shows, :updated_at, :datetime
  end

end
