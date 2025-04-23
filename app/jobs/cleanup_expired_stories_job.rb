class CleanupExpiredStoriesJob < ApplicationJob
  queue_as :default

  def perform
    Story.where("expires_at <= ?", Time.current).destroy_all
  end
end

every 1.hour do
  runner "CleanupExpiredStoriesJob.perform_later"
end
