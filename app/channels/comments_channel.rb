class CommentsChannel < ApplicationCable::Channel
  def subscribed
    if params["post_id"].present?
      stream_from "comments_post_#{params["post_id"]}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
