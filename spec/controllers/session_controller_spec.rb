require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  before(:all)do
    @user = User.create(username: "guilfoyle", email: "guilfoyle@mail.com", password: "password", role: 0)

  end

  describe "create sessions"do

    it "create new session if credentials correct"do
      
    end


  end


end
