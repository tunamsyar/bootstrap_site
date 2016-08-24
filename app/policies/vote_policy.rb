class VotePolicy < ApplicationPolicy

  def upvote
    user.present?
  end

  def downvote
    upvote
  end
