class AddMissingColumnsToReels < ActiveRecord::Migration[8.0]
  def change
    add_column :reels, :view_count, :integer, default: 0
    add_column :reels, :featured, :boolean, default: false
  end
end
