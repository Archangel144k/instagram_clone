# filepath: app/models/post_save.rb
class PostSave < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
