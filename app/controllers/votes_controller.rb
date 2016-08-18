class VotesController < ApplicationController
  respond_to :js
  before_action :authenticate!

  def upvote
    update_vote(1)
    VoteBroadcastJob.perform_now(@vote.comment)
    flash.now[:success] = "You've Upvoted"

  end

  def downvote
    update_vote(-1)
    VoteBroadcastJob.perform_now(@vote.comment)
    flash.now[:alert] = "You've Downvoted"
  end

  private

  def find_by_create_vote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
  end

  def update_vote(value)
      find_by_create_vote
      @vote.update(value: value)
  end

end
