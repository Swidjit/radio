class CreateHistory < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :resource_type
      t.integer :resource_id
      t.belongs_to :user
      t.timestamps
    end
  end
end
