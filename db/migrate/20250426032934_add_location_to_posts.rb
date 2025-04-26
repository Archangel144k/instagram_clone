class AddLocationToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :location, :string
  end
end
