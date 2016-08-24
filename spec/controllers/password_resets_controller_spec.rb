require "rails_helper"

RSpec.describe PasswordResetsController, type: :controller do

  before(:all)do
    @user = User.create(username: "guilfoyle", email: "guilfoyle@mail.com", password: "password", role: 0)
  end

  describe "new" do
    it "renders new"do
      get :new

      expect(subject).to render_template(:new)
    end
  end

  describe "create new password"do
    it "should set token and date"do
      params = {reset: {email: @user.email}}

      post :create, params: params

      @user.reload

      expect(ActionMailer::Base.deliveries.count).to eql(1)
      expect(@user.password_reset_token).to be_present
      expect(@user.password_reset_at).to be_present
      expect(flash[:success]).to eql("We've sent you instructions on how to reset your password")
    end

    it "should warn if email not found"do

      params = {reset:  {email: "dinesh@mail.com"}}

      post :create, params: params

      expect(flash[:danger]).to eql("User does not exist")
    end
  end

  describe "edit password" do
    it "should redirect to edit" do
      params = {id: "resettoken"}

      get :edit, params: params

      expect(subject).to render_template(:edit)

    end
  end

  describe "update password" do

    it "should update password" do
      params = {reset: {email: @user.email}}

      post :create, params: params

      @user.reload

      params = {id: @user.password_reset_token, user: {password: "newpassword"}}

      patch:update, params: params

      @user.reload

      user = @user.authenticate("newpassword")

      expect(user.password_reset_token).to be_nil
      expect(user.password_reset_at).to be_nil
      expect(user).to be_present
      expect(flash[:success]).to eql("Password updated, you may log in now")
      expect(subject).to redirect_to(root_path)
    end

    it "should not allow to update if invalid token" do
      params = {reset: {email: @user.email}}
      post :create, params: params

      @user.reload

      params = {id: "wrongtoken", user: {password: "newpassword"}}
      patch :update, params: params
      expect(flash[:danger]).to eql "Error, token is invalid or has expired"
      expect(subject).to redirect_to(edit_password_reset_path(id: "wrongtoken"))
      expect(@user.password_reset_token).to be_present
    end
  end

end
