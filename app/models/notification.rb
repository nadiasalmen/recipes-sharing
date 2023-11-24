# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  after_create :stream_notification

  private

  def stream_notification
    user.followers.each do |follower|
      message_data = {
        user_id: user_id,
        message: message,
        follower_id: follower.id
      }
      ActionCable.server.broadcast "notifications_#{follower.id}", message_data
    end
  end
end
