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
  
  # Notifications
  has_many :notifications, dependent: :destroy
  
  # Reels
  has_many :reels, dependent: :destroy

  # Stories
  has_many :stories, dependent: :destroy
  has_many :story_views, dependent: :destroy
  has_many :viewed_stories, through: :story_views, source: :story

  # Saves
  has_many :saves, dependent: :destroy
  has_many :saved_posts, through: :saves, source: :saveable, source_type: 'Post'
  
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
    following << user unless self == user || following?(user)
  end
  
  def unfollow(user)
    following.delete(user)
  end
  
  def following?(user)
    following.include?(user)
  end

  # Returns a URL for the user's avatar. Accepts any arguments (positional or keyword).
  def avatar_url(*args, **kwargs)
    # Determine size and style from positional args or keyword args
    size = args[0] || kwargs[:size] || 100
    style = args[1] || kwargs[:style]

    if avatar.attached?
      variant = if style == :thumb
        avatar.variant(resize_to_fill: [size, size]).processed
      else
        avatar.variant(resize_to_fill: [size, size]).processed
      end
      Rails.application.routes.url_helpers.rails_representation_url(variant, only_path: true)
    else
      "https://ui-avatars.com/api/?name=#{username}&size=#{size}"
    end
  end

  # Avatar variants for optimization
  def avatar_variant(size = :medium)
    return unless avatar.attached?
    case size
    when :thumb
      avatar.variant(resize_to_fill: [80, 80]).processed
    when :medium
      avatar.variant(resize_to_limit: [400, 400]).processed
    else
      avatar
    end
  end

  def likes?(likeable)
    likeable.likes.where(user_id: id).exists?
  end

  def saved?(post)
    # Directly check the saves association for the specific post
    saves.exists?(saveable_id: post.id, saveable_type: 'Post')
  end

  def admin?
    self.admin == true
  end

  def make_admin!
    update(admin: true)
  end

  def revoke_admin!
    update(admin: false)
  end

  private

  def add_protocol_to_website
    return if website.blank? || website[/\Ahttp(s)?:\/\//]

    self.website = "http://#{website}"
  end
end
