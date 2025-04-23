class Post < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_one_attached :image
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :saves, as: :saveable, dependent: :destroy

  # For saved posts functionality
  has_many :post_saves, class_name: "PostSave", dependent: :destroy
  has_many :saved_by_users, through: :post_saves, source: :user

  # Validations
  validates :image, presence: true
  validates :caption, length: { maximum: 2200 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Methods to check if a user has liked/saved this post
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  def saved_by?(user)
    saved_by_users.include?(user)
  end
end
