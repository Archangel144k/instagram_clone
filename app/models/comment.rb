class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  
  validates :body, presence: true
  
  # Your additional comment model code...
end
