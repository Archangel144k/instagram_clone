class Story < ApplicationRecord
  belongs_to :user
  has_one_attached :media

  validates :media, presence: true
  validates :expires_at, presence: true

  # Scope to fetch only active (non-expired) stories
  scope :active, -> { where("expires_at > ?", Time.current) }

  # Automatically set expiration time (24 hours from creation)
  before_validation :set_expiration, on: :create

  private

  def set_expiration
    self.expires_at ||= 24.hours.from_now
  end
end
