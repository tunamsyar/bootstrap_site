require 'rails_helper'

RSpec.describe PasswordResetsMailer, type: :mailer do

  before(:all)do
    @user = User.create(username: "guilfoyle", email: "guilfoyle@mail.com", password: "password", role: 0)
  end

  describe "should send email"do
    it "should send email with password"do
      @user.update(password_reset_token: "resettoken", password_reset_at: DateTime.now)
      binding.pry

      mail = PasswordResetsMailer.password_reset_mail(@user)

      expect(mail.to[0]).to eql(@user.email)
      expect(mail.body.include?("http://localhost:3000/password_resets/#{@user.password_reset_token}/edit")).to eql(true)
    end

  end

end
