require 'rails_helper'

RSpec.describe Topic, type: :model do

  context "association"do
    it { should have_many(:posts)}
  end

  context "title validation"do
    it { should validate_presence_of(:title)}
    it { should validate_length_of(:title).is_at_least(5)}
  end

  context "description validation" do
    it { should validate_presence_of(:description)}
    it { should validate_length_of(:description).is_at_least(5)}
  end

  context "slug callback" do
    it "set slug"do
      topic = (create :topic)
      expect(topic.title.gsub(" ", "-").downcase).to eql(topic.slug)
    end

    # it "should update slug"do
    #   topic = (create :topic)
    #   topic.update(title: "new_topic")
    #   binding.pry
    #
    #   expect(topic.slug).to eql("new_topic")
    # end TO UPDATE SLUG UPDATING
  end
end
