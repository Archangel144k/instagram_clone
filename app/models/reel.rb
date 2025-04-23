class Reel < ApplicationRecord
  belongs_to :user
  has_one_attached :video
  
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :saves, as: :saveable, dependent: :destroy
  has_many :saved_by_users, through: :saves, source: :user
  
  validates :video, presence: true
  validates :caption, length: { maximum: 2200 }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :trending, -> { order(view_count: :desc).where('created_at > ?', 7.days.ago) }
  scope :featured, -> { where(featured: true) }
  
  def increment_view_count!
    increment!(:view_count)
  end
end
