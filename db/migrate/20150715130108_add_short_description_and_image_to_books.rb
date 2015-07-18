class AddShortDescriptionAndImageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :short_description, :text
    add_column :books, :image, :string
  end
end
