class AddBandYears < ActiveRecord::Migration
  def change
    add_column :bands, :years, :text, :array=>:true
  end
end
