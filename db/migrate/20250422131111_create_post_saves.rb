class CreatePostSaves < ActiveRecord::Migration[8.0]
  def up
    create_table :post_saves do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end

    # Add the index only if it doesn't already exist
    unless index_exists?(:post_saves, [:user_id, :post_id], unique: true)
      add_index :post_saves, [:user_id, :post_id], unique: true
    end
  end

  def down
    # Remove the index only if it exists
    if index_exists?(:post_saves, [:user_id, :post_id], unique: true)
      remove_index :post_saves, column: [:user_id, :post_id]
    end

    drop_table :post_saves
  end
end
