class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :media
  has_many :story_views, dependent: :destroy

  scope :active, -> { where('expires_at > ?', Time.current) }
  scope :for_feed, ->(user) { where(user: [user] + user.following).active.order(created_at: :desc) }

  validates :media, presence: true
  validates :expires_at, presence: true

  # Automatically set expires_at to 24 hours from now
  before_validation :set_expires_at, on: :create

  private

  def set_expires_at
    self.expires_at ||= 24.hours.from_now
  end
end
