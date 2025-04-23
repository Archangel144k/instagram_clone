class CreateReels < ActiveRecord::Migration[8.0]
  def change
    create_table :reels do |t|
      t.text :caption
      t.references :user, null: false, foreign_key: true
      t.float :duration

      t.timestamps
    end
  end
end
