class VoteBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast "votes_channel", comment_id: comment.id, value: comment.total_votes, value1: comment.total_upvote, value2: comment.total_downvote
  end


end
