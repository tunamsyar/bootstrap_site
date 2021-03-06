class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :comments, dependent: :destroy
   belongs_to :topic
   belongs_to :user
   mount_uploader :image, ImageUploader
   validates :title, length: { minimum: 5 }, presence: true
   validates :body, length: { minimum: 5 }, presence: true
end
