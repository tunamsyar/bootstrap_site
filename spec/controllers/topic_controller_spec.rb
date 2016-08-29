require 'rails_helper'

RSpec.describe TopicsController, type: :controller do

  before(:all) do
    @user = create(:user, :admin)
    @invalid = create(:user, :sequenced_email, :sequenced_username)

  end

  describe "create topic" do
    it "should redirect if not logged in" do
      params = {topic: {title: "new topic", description: "newly created topic", haha_spam: "spam" }}
      post :create, params: params
      binding.pry

      expect(Topic.count).to eql(0)
      expect(flash[:danger]).to eql("You need to login first")
      expect(subject).to redirect_to(root_path)
    end

    it "should create topic if admin account"do
      params = {topic: {title: "new topic", description: "suicide squad"}}
      post :create, xhr: true, params: params, session: {id: @user.id}

      topic = Topic.find_by(title: "new topic")

      expect(Topic.count).to eql(1)
      expect(topic.title).to eql("new topic")
      expect(flash[:success]).to eql("You've created a new topic.")

    end

    it "should not create topic if non admin account"do
      params = {topic: {title: "new topic", description: "suicide squad"}}
      post :create,xhr: true, params: params, session: {id: @invalid.id}
      expect(Topic.count).to eql(0)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "edit topic" do
    it "should deny unauthorized user" do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id}
      get :edit, params: params, session: {id: @invalid.id}

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should deny unlogged in user"do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id}
      get :edit, params: params

      expect(flash[:danger]).to eql("You need to login first")
      expect(subject).to redirect_to(root_path)
    end

    it "should allow if admin user" do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id}
      get :edit, params: params, session: {id: @user.id}

      expect(subject).to render_template(:edit)
    end

  end

  describe "delete topic"do

    it "delete if topic admin"do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id}
      delete :destroy, xhr: true,params: params, session: {id: @user.id}

      expect(flash[:success]).to eql("Topic suda delete da..")
    end

    it "no delete if non admin"do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id}
      delete :destroy, xhr: true,params: params, session: {id: @invalid.id}

      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "no delete if no user login" do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id}
      delete :destroy, xhr: true,params: params

      expect(flash[:danger]).to eql("You need to login first")
    end

  end

  describe "update topic" do

    it "update if admin" do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)
      params ={id: @topic.id, topic: {title: "topics"}}

      patch :update,xhr: true, params: params, session: {id: @user.id}
      expect(flash[:success]).to eql("Topic Updated")

    end

    it "does not update if non admin" do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)

      params ={id: @topic.id, topic: {title: "topics"}}

      patch :update,xhr: true, params: params, session: {id: @invalid.id}
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "does not update when no user logged in" do
      @topic = Topic.create(title: "new topic", description: "new topics", id: "1",user_id: @user)

      params ={id: @topic.id, topic: {title: "topics"}}

      patch :update,xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")

    end

  end

end
