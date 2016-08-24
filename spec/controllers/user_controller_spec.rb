require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) do
    @user = User.create(username: "guilfoyle", email: "guilfoyle@piedpiper.com", password: "password")
    @invalid = User.create(username: "dinesh", email: "dinesh@piedpiper.com", password: "password")
  end

  describe "create user" do
    it "should create new user" do

      params={ user: {email: "user@mail.com", username: "erlich", password: "password", password_confirmation:"password" } }
      post :create, params: params

      user = User.find_by(email: "user@mail.com")
      expect(User.count).to eql(3)
      expect(user.email).to eql("user@mail.com")
      expect(user.username).to eql("erlich")
      expect(flash[:success]).to eql("New User created")
    end

    it "should not create new user"do

      params={ user: {email: "user@mail.com", username: "erlich", password: "password", password_confirmation:"password123" } }
      post :create, params: params

      user = User.find_by(email: "user@mail.com")
      expect(User.count).to eql(2)

    end
  end

  describe "update user"

  it "should update user" do
    params= {id: @user.id, user: {username: "richard", email:"new@mail.com", password:"abcd123", password_confirmation: "abcd123" } }
    patch :update, params: params, session: {id: @user.id}

    @user.reload
    current_user = subject.send(:current_user).reload

    expect(current_user.email).to eql("new@mail.com")
    expect(current_user.username).to eql("richard")
    expect(current_user.authenticate("abcd123")).to eql(@user)
  end

end
