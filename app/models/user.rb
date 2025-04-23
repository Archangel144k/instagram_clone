require 'digest/md5'

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # Avatar attachment
  has_one_attached :avatar
  
  # Post associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  # Follow associations
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
  
  # Saved posts
  has_many :post_saves,
           class_name: "PostSave",
           dependent: :destroy
  has_many :saved_posts,
           through:  :post_saves,
           source:   :post

  # Polymorphic saves association
  has_many :saves, dependent: :destroy
  has_many :saved_posts, -> { where(saves: { saveable_type: 'Post' }) }, through: :saves, source: :saveable, source_type: 'Post'
  has_many :saved_reels, -> { where(saves: { saveable_type: 'Reel' }) }, through: :saves, source: :saveable, source_type: 'Reel'
  
  # Notifications
  has_many :notifications, dependent: :destroy
  
  # Reels
  has_many :reels, dependent: :destroy

  # Stories
  has_many :stories, dependent: :destroy
  
  # Profile information
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :bio, length: { maximum: 150 }
  validates :website, format: {
    with: /\A(http(s)?:\/\/)?(www\.)?[\w\-]+\.[a-z]{2,}(\.[a-z]{2,})?(\/.*)?\z/i,
    message: "must be a valid URL"
  }, allow_blank: true

  before_validation :add_protocol_to_website
  
  # Follow methods
  def follow(user)
    following << user unless self == user || following.include?(user)
  end
  
  def unfollow(user)
    following.delete(user)
  end
  
  def following?(user)
    following.include?(user)
  end

  def avatar_url(size: 100)
    if avatar.attached?
      # Use a simpler approach that doesn't require full URL generation
      "data:#{avatar.content_type};base64,#{Base64.strict_encode64(avatar.download)}"
    else
      "https://ui-avatars.com/api/?name=#{username}&size=#{size}"
    end
  end

  def likes?(likeable)
    likeable.likes.where(user_id: id).exists?
  end

  def saved?(saveable)
    saves.exists?(saveable: saveable)
  end

  def saved?(post)
    saved_posts.include?(post)
  end

  private

  def add_protocol_to_website
    return if website.blank? || website[/\Ahttp(s)?:\/\//]

    self.website = "http://#{website}"
  end
end
