require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  before(:all)do
    @user = create(:user)
    @invalid =create(:user, :sequenced_email, :sequenced_username)
    @admin = create(:user, :admin, :sequenced_email, :sequenced_username)
    @topic = create(:topic)
    @post = create(:post, :sequenced_title, :sequenced_body, topic_id: @topic.id, user_id: @user.id)
  end

  describe "index comments"do
    it "renders index"do
      @comment = Comment.create(body:"new commentes")
      params = {topic_id: @topic.id,post_id: @post.id}
      get :index, params: params

      expect(subject).to render_template(:index)
      expect(Comment.count).to eql(1)
    end
  end

  describe "create comments"do

    it "denies unlogged in user" do
      params = {topic_id: @topic.id, post_id: @post.id}
      get :new, params: params

      expect(flash[:danger]).to eql("You need to login first")
      expect(subject).to redirect_to(root_path)
    end

    it "authorized user"do
      params = {topic_id: @topic.id, post_id: @post.id, comment: {body:"new commentes"}}
      post :create, xhr: true, params: params, session: {id: @user.id}

      @comment= Comment.first
      expect(@user.comments.count).to eql(1)
      expect(@comment.body).to eql("new commentes")
      expect(flash[:success]).to eql("Comment created")
    end

  end

  describe "update comments"do

    it "denies unlogged in user" do
      @comment = Comment.create(body:"new commentes", id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: {body: "new new new"}}
      patch :update, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "denies unauthorized user" do
      @comment = Comment.create(body:"new commentes",post_id: 1, id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: {body: "new new new"}}
      patch :update, xhr: true, params: params, session: {id: @invalid.id}

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "allows authorized user" do
      @comment = Comment.create(body:"new commentes",post_id: 1, id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @post.id, id: @comment.id, comment: {body: "new new new"}}
      patch :update, xhr: true, params: params, session: {id: @user.id}

      @comment.reload

      expect(flash[:success]).to eql("You've created a comment")
      expect(@comment.body).to eql("new new new")

    end

  end

  describe "delete comments" do
    it "denies unlogged in user" do
      @comment = Comment.create(body:"new commentes",post_id: 1, id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @post.id, id: @comment.id}

      delete :destroy, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "denies unauthorized user" do
      @comment = Comment.create(body:"new commentes",post_id: 1, id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @post.id, id: @comment.id}

      delete :destroy, params: params, session: {id: @invalid.id}

      expect(flash[:danger]).to eql("You're not authorized")

    end

    it "allows authorized user"do
      @comment = Comment.create(body:"new commentes",post_id: 1, id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @comment.post_id, id: @comment.id}
      delete :destroy, xhr: true, params: params, session: {id: @user.id}

      expect(flash[:success]).to eql("Delete batang hidung mu!")
      expect(@user.comments.count).to eql(0)

    end

    it "allows admin to delete"do
      @comment = Comment.create(body:"new commentes",post_id: 1, id: 1, user_id: @user.id)
      params = {topic_id: @topic.id, post_id: @comment.post_id, id: @comment.id}
      delete :destroy, xhr: true, params: params, session: {id: @admin.id}

      expect(flash[:success]).to eql("Delete batang hidung mu!")
      expect(@user.comments.count).to eql(0)

    end

  end




end
