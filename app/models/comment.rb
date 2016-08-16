class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5 }, presence: true
end
