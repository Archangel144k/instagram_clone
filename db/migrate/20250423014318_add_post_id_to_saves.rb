class AddPostIdToSaves < ActiveRecord::Migration[8.0]
  def change
    add_reference :saves, :post, null: false, foreign_key: true
  end
end
