# filepath: app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations.includes(:messages, :users).order('messages.created_at DESC')
  end

  def show
    @conversation = current_user.conversations.includes(messages: :user).find(params[:id])
    @message = Message.new # For the new message form
    # Mark messages as read logic here later
  end

  # Creates or finds conversation between current_user and params[:user_id]
  def create
    recipient = User.find(params[:user_id])
    # Try to find existing conversation
    existing_conversation = Conversation.between(current_user.id, recipient.id).first

    if existing_conversation
      redirect_to conversation_path(existing_conversation)
    else
      @conversation = Conversation.create!
      @conversation.user_conversations.create!(user: current_user)
      @conversation.user_conversations.create!(user: recipient)
      redirect_to conversation_path(@conversation), notice: "Conversation started with #{recipient.username}"
    end
  end
end