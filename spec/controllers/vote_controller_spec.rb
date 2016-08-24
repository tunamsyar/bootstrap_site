require'rails_helper'

RSpec.describe VotesController, type: :controller do
  before(:all)do
    @comment = Comment.create(body:"new commentes",id: "1")
    @user = User.create(username: "guilfoyle", email: "guilfoyle@mail.com", password: "password", role: 0)
    @invalid = User.create(username: "dinesh", email: "dinesh@mail.com", password: "password", role: 0)
  end

  describe("upvote")do
  
    it "no user logged in" do
      params = {comment_id: @comment.id}

      post :upvote, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "user logged in" do
      params = {comment_id: @comment.id}

      post :upvote, xhr: true, params: params, session: {id: @user.id}

      expect(flash[:success]).to eql("You've Upvoted!")
    end

  end

  describe("downvote")do

    it "no user logged in" do
      params = {comment_id: @comment.id}

      post :downvote, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "user logged in" do
      params = {comment_id: @comment.id}

      post :downvote, xhr: true, params: params, session: {id: @user.id}

      expect(flash[:alert]).to eql("You've Downvoted!")
    end

  end

end
