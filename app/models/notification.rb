class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  # Add this scope for unread notifications
  scope :unread, -> { where(read: false) }
  
  # Method to mark as read
  def mark_as_read!
    update(read: true)
  end
end
