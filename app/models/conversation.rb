class Conversation < ApplicationRecord
  has_many :user_conversations, dependent: :destroy
  has_many :users, through: :user_conversations
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy

  # Scope to find a conversation between two specific users
  scope :between, -> (sender_id, recipient_id) do
    joins(:users).where(users: { id: sender_id }).joins(:users).where(users: { id: recipient_id }).distinct
  end

  # Helper to get the other user in a 1-on-1 conversation
  def other_user(current_user)
    users.where.not(id: current_user.id).first
  end
end
