class AddFirstnameAndLastnameToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :firstname, :string
    add_column :addresses, :lastname, :string
  end
end
