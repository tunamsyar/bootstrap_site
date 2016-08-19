class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :votes, dependent: :destroy
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5 }, presence: true

  def total_votes
    votes.pluck(:value).sum
  end

  def total_upvote
    votes.where(value: 1).count
  end

  def total_downvote
    votes.where(value: -1).count
  end
  
end
