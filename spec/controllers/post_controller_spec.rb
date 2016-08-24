require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  before(:all) do
    @user = User.create(username: "guilfoyle", email: "guilfoyle@mail.com", password: "password", role: 0)
    @invalid = User.create(username: "dinesh", email: "dinesh@mail.com", password: "password", role: 0)
    @admin = User.create(username: "richard", email: "richard@mail.com", password: "password", role: 2)
    @topic = Topic.create(title: "new topic", description: "new topics", id: "1")
    @post = Post.create(title:"new post", body: "new posts", topic_id: "1", user_id: @user.id)
  end

  describe "index posts"do
    it "render index" do
      params = {topic_id: @topic.id}
      get :index, params: params

      expect(subject).to render_template(:index)
      expect(Post.count).to eql(1)
    end
  end

  describe "create post" do
    it "create post without account"do
      params = {topic_id: @topic.id}
      get :new, params: params

      expect(Post.count).to eql(1)
      expect(flash[:danger]).to eql("You need to login first")
      expect(subject).to redirect_to(root_path)
    end

    it "create post with account"do
      params = {topic_id: @topic.id, post: {title: "new postes", body: "new postedes" } }
      post :create, xhr: true, params: params, session: {id: @user.id}
      post = @user.posts.second

      expect(@user.posts.count).to eql(2)
      expect(post.title).to eql("new postes")
      expect(post.body).to eql("new postedes")
      expect(flash[:success]).to eql("You've created a new post.")
    end

  end

  describe "edit post"do

    it "edits belonging to user"do
    @post= Post.first
    params = {topic_id: @topic.id, id: @post.id}
    get :edit, xhr: true, params: params, session: {id: @user.id}

    expect(subject).to render_template(:edit)

    end

    it "edits not belong to user"do
      @post= Post.first
      params = {topic_id: @topic.id, id: @post.id}
      get :edit, xhr: true, params: params, session: {id: @invalid.id}

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "edits not belong to user BUT as Admin"do
      @post= Post.first
      params = {topic_id: @topic.id, id: @post.id}
      get :edit, xhr: true, params: params, session: {id: @user.id}

      expect(subject).to render_template(:edit)
    end

    it "edits no user login"do
      @post= Post.first
      params = {topic_id: @topic.id, id: @post.id}
      get :edit, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end
  end

  describe "update post" do
    it "updates belong to user"do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id, post: {title: "updates post", body: "updating post"}}
      patch :update, xhr: true, params: params, session: {id: @user.id}

      @post.reload

      expect(@post.title).to eql("updates post")
      expect(@post.body).to eql("updating post")
      expect(@user.posts.count).to eql(1)

    end

    it "updates not belong to user"do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id, post: {title: "updates post", body: "updating post"}}
      patch :update, xhr: true, params: params, session: {id: @invalid.id}

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "updates without user"do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id, post: {title: "updates post", body: "updating post"}}
      patch :update, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

  end

  describe "delete post" do

    it "deletes post belonging to user"do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id}

      delete :destroy,xhr: true, params: params, session: {id: @user.id}

      expect(flash[:success]).to eql("Post suda tada")
      expect(@user.posts.count).to eql(0)
    end

    it "deny delete for unauthorized user"do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id}

      delete :destroy,xhr: true, params: params, session: {id: @invalid.id}
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "deny delete for unlogged in user"do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id}

      delete :destroy,xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "delete for admin user" do
      @post = Post.first
      params = {topic_id: @topic.id, id: @post.id}

      delete :destroy,xhr: true, params: params, session: {id: @admin.id}

      expect(flash[:success]).to eql("Post suda tada")
      expect(@user.posts.count).to eql(0)

    end
  end


end
