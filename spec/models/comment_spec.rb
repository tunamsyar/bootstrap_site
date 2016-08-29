require 'rails_helper'

RSpec.describe Comment, type: :model do

  context "association"do
    it {should have_many(:votes)}
  end

  context "body validation"do
    it {should validate_length_of(:body).is_at_least(5)}
    it {should validate_presence_of(:body)}
  end

  context "total votes" do
    it "should give 0 if no votes" do
      comment = create(:comment)

      expect(comment.total_votes).to eql(0)
    end

    it "should calculate the correct vote score" do
      comment = create(:comment)
      user = create(:user)

      10.times.each { |x| user.votes.create(comment_id: comment.id, value: x % 3 == 0 ? -1 : 1 )}

      expect(comment.total_votes).to eql(2)
    end
  end

end
