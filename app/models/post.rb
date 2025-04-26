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
    saves.exists?(user_id: user.id)
  end

  # Image variants for optimization
  def image_variant(size = :medium)
    return unless image.attached?
    case size
    when :thumb
      image.variant(resize_to_fill: [80, 80]).processed
    when :medium
      image.variant(resize_to_limit: [400, 400]).processed
    else
      image
    end
  end
end
