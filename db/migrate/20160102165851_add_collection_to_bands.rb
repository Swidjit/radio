class AddCollectionToBands < ActiveRecord::Migration
  def change
    add_column :bands, :collection, :string
  end
end
