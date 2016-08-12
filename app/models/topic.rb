class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5 }, presence: true
end
