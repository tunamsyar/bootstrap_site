require 'rails_helper'

RSpec.describe Post, type: :model do
  context "association" do
    it {should have_many(:comments)}
  end

  context "title validation"do
    it {should validate_presence_of(:title)}
    it {should validate_length_of(:title).is_at_least(5)}
  end

  context "body validation"do
    it {should validate_presence_of(:body)}
    it {should validate_length_of(:body).is_at_least(5)}
  end

  context "slug callback" do
    it "set slug"do
      post = (create :post)
      expect(post.title.gsub(" ","-").downcase).to eql(post.slug)
    end
  end
end
