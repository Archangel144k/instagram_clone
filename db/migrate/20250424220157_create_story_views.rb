class CreateStoryViews < ActiveRecord::Migration[7.0]
  def change
    create_table :story_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :story, null: false, foreign_key: true

      t.timestamps
    end
    
    # Optional: Add a unique index to prevent duplicate views
    add_index :story_views, [:user_id, :story_id], unique: true
  end
end
