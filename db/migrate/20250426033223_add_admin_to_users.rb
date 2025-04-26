class AddAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin, :boolean, default: false
    
    # Optional: Add index for faster queries on admin status
    add_index :users, :admin
  end
end
