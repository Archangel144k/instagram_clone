class Like < ApplicationRecord
  include PublicActivity::Model
  # Fix the tracked owner to handle nil controller during seeds
  tracked owner: Proc.new{ |controller, model| controller&.current_user || model.user },
          recipient: Proc.new{ |controller, model| model.likeable.user }

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
