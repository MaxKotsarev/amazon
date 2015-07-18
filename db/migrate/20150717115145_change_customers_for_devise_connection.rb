  class ChangeCustomersForDeviseConnection < ActiveRecord::Migration
    def change
      ## Database authenticatable             
      change_column :customers, :email, :string, null: false, default: ""
      remove_column :customers, :password
      add_column :customers, :encrypted_password, :string, null: false, default: ""

      ## Recoverable
      add_column :customers, :reset_password_token, :string
      add_column :customers, :reset_password_sent_at, :datetime

      ## Rememberable
      add_column :customers, :remember_created_at, :datetime

      ## Trackable
      add_column :customers, :sign_in_count, :integer, default: 0, null: false
      add_column :customers, :current_sign_in_at, :datetime
      add_column :customers, :last_sign_in_at, :datetime
      add_column :customers, :current_sign_in_ip, :string
      add_column :customers, :last_sign_in_ip, :string

      add_index :customers, :email,                unique: true
      add_index :customers, :reset_password_token, unique: true
    end
  end
