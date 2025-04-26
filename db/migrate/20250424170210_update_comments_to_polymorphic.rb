class UpdateCommentsToPolymorphic < ActiveRecord::Migration[7.0]
  def change
    # Remove the NOT NULL constraint from post_id temporarily
    change_column_null :comments, :post_id, true
    
    # Add the polymorphic columns if they don't exist
    unless column_exists?(:comments, :commentable_type)
      add_column :comments, :commentable_type, :string
      add_column :comments, :commentable_id, :integer
    end
    
    # Populate the polymorphic fields from existing post_id values
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE comments
          SET commentable_type = 'Post', commentable_id = post_id
          WHERE post_id IS NOT NULL
        SQL
      end
    end
    
    # Add indices for the polymorphic relationship
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
