class Topic < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :posts, dependent: :destroy
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5 }, presence: true
  belongs_to :user
end
