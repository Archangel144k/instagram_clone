class AddPolymorphicAttributesToComments < ActiveRecord::Migration[8.0]
  def change
    # First check if the columns exist to avoid errors
    unless column_exists?(:comments, :commentable_type)
      add_column :comments, :commentable_type, :string
    end
    
    unless column_exists?(:comments, :commentable_id)
      add_column :comments, :commentable_id, :integer
    end
    
    # Create index for better performance
    add_index :comments, [:commentable_type, :commentable_id], name: 'index_comments_on_commentable'
    
    # If you have an existing direct post_id column, migrate the data
    if column_exists?(:comments, :post_id)
      # Data migration code
      reversible do |dir|
        dir.up do
          execute <<-SQL
            UPDATE comments
            SET commentable_id = post_id, commentable_type = 'Post'
            WHERE post_id IS NOT NULL
          SQL
          
          # Optionally remove the post_id column if everything is migrated
          # remove_column :comments, :post_id
        end
      end
    end
  end
end
