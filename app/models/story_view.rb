# app/models/story_view.rb
class StoryView < ApplicationRecord
  belongs_to :user
  belongs_to :story

  validates :user_id, uniqueness: { scope: :story_id, message: "has already viewed this story" }
end