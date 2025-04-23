class AddPolymorphicToSaves < ActiveRecord::Migration[6.1]
  def change
    # Remove the old column if it exists
    if column_exists?(:saves, :post_id)
      remove_column :saves, :post_id, :integer
    end

    # Add polymorphic reference only if it doesn't already exist
    unless column_exists?(:saves, :saveable_type) && column_exists?(:saves, :saveable_id)
      add_reference :saves, :saveable, polymorphic: true, null: false
    end
  end
end
