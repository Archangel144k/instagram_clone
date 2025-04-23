class CreateSaves < ActiveRecord::Migration[8.0]
  def change
    create_table :saves do |t|
      t.references :user, null: false, foreign_key: true
      t.references :saveable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
