# filepath: app/controllers/conversations/messages_controller.rb
module Conversations
  class MessagesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_conversation

    def create
      @message = @conversation.messages.build(message_params)
      @message.user = current_user # Set sender

      if @message.save
        # Redirect back to conversation show page
        # Later: Use Turbo Streams or Action Cable to broadcast
        redirect_to conversation_path(@conversation), notice: 'Message sent!'
      else
        # Need to reload conversation data for rendering show
        @messages = @conversation.messages.includes(:user) # Reload messages
        flash.now[:alert] = "Message could not be sent."
        render 'conversations/show', status: :unprocessable_entity
      end
    end

    private

    def set_conversation
      @conversation = current_user.conversations.find(params[:conversation_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to conversations_path, alert: "Conversation not found."
    end

    def message_params
      params.require(:message).permit(:body)
    end
  end
end