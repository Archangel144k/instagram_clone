class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:create]

  def create
    # @commentable is set by the before_action
    unless @commentable
      Rails.logger.error("[CommentsController] Commentable not found. Params: #{params.inspect}")
      respond_to do |format|
        format.html {
          render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false
        }
        format.json { render json: { success: false, errors: ['Commentable resource not found.'] }, status: :not_found }
      end
      return
    end

    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # Log before broadcasting the new comment to Action Cable
      Rails.logger.info("[CommentsController] Broadcasting comment: commentable=")
      Rails.logger.info(@commentable.inspect)
      Rails.logger.info("[CommentsController] Comment: ")
      Rails.logger.info(@comment.inspect)

      if @commentable.is_a?(Post)
        ActionCable.server.broadcast(
          "comments_post_#{@commentable.id}",
          comment: ApplicationController.render(
            partial: 'comments/comment',
            locals: { comment: @comment, current_user: nil },
            formats: [:html]
          )
        )
      end

      # Add notification logic (DRY suggestion)
      # Notification.create(recipient: @commentable.user, actor: current_user, action: "commented on", notifiable: @commentable) unless @commentable.user == current_user

      respond_to do |format|
        format.html { redirect_back(fallback_location: polymorphic_path(@commentable)) }
        format.json {
          render json: {
            success: true,
            comment: { # Nest comment details
              id: @comment.id,
              body: @comment.body,
              created_at: @comment.created_at.strftime('%b %d, %Y %I:%M %p'), # Format timestamp
              user: { # Nest user details
                username: current_user.username,
                avatar_url: current_user.avatar_url(size: 32)
              }
            },
            count: @commentable.comments.count
          }, status: :created # Use 201 status for creation
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:alert] = t('comments.create.error', default: "Comment could not be saved: #{@comment.errors.full_messages.join(', ')}")
          redirect_back(fallback_location: polymorphic_path(@commentable))
        }
        format.json { render json: { success: false, errors: @comment.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @commentable = @comment.commentable
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js # renders destroy.js.erb
    end
  end

  private

  def set_commentable
    if params[:post_id]
      @commentable = Post.friendly.find(params[:post_id])
    elsif params[:reel_id]
      @commentable = Reel.find_by(id: params[:reel_id])
    # Check for parameters sent directly (e.g., via FormData from JS)
    elsif params[:commentable_type].present? && params[:commentable_id].present?
      commentable_type_str = params[:commentable_type].classify
      commentable_type = commentable_type_str.safe_constantize
      if commentable_type
        @commentable = commentable_type.find_by(id: params[:commentable_id])
      else
        Rails.logger.error("Invalid commentable_type provided: #{params[:commentable_type]}")
        @commentable = nil
      end
    else
      # Fallback or error if no identifiable parent parameter is found
      Rails.logger.error("Could not determine commentable resource from params: #{params.inspect}")
      @commentable = nil
    end

    # Log if the resource ID looks suspicious
    suspicious_id = [params[:post_id], params[:reel_id], params[:commentable_id]].compact.find { |id| !id.to_s.match?(/^\d+$/) }
    if suspicious_id
       Rails.logger.warn("Suspicious non-numeric ID found for commentable: #{suspicious_id}")
    end

    # Handle case where ID was provided but record not found
    if (params[:post_id] || params[:reel_id] || params[:commentable_id]) && @commentable.nil?
      Rails.logger.error("Commentable resource not found with ID: #{params[:post_id] || params[:reel_id] || params[:commentable_id]} and Type: #{params[:commentable_type]}")
      # Optionally set an alert or specific error message here if needed for the user
    end
  end

  def comment_params
     params.require(:comment).permit(:body)
  end

  def respond_with_comment_error(message)
    respond_to do |format|
      format.html {
        flash[:alert] = message
        redirect_back(fallback_location: root_path)
      }
      format.json { render json: { success: false, errors: [message] }, status: :unprocessable_entity }
    end
  end
end