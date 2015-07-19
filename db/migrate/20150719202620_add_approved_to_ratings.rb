class AddApprovedToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :approved, :boolean
  end
end
