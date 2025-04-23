class Like < ApplicationRecord
  include PublicActivity::Model
  # Track who created the like (owner) and notify the post owner (recipient)
  tracked owner: Proc.new{ |controller, model| controller.current_user },
          recipient: Proc.new{ |controller, model| model.likeable.user }

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
