class AddCaptionToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :caption, :text
  end
end
