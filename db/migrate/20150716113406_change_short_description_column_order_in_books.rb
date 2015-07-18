class ChangeShortDescriptionColumnOrderInBooks < ActiveRecord::Migration
  def change
    change_column :books, :short_description, :text, after: :title
  end
end
