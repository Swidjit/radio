class AddSourceToReactions < ActiveRecord::Migration
  def change
    add_column :reactions, :reaction_source, :string
  end
end
