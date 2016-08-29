require 'rails_helper'

RSpec.describe User, type: :model do
  context "association" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should have_many(:topics) }
  end

  context "email validation" do
    it { should allow_value("user@gmail.com").for(:email) }
    #TO ADD EMAIL VALIDATION,UNIQUENESS, FORMAT
  end

end
