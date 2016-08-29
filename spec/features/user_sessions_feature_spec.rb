require 'rails_helper'

RSpec.feature "User Sessions", type: :feature, js: true do

  before(:all)do
    @user = create :user
  end

  scenario "user login"do
    visit root_path
    click_link('Login')
    fill_in 'email_field', with: @user.email
    fill_in 'password_field', with: @user.password
    click_button('Login')

    expect(page).to have_current_path(root_path)
    expect(find('.message').text).to eql("Welcome back #{@user.username}")
  end

  scenario "user at login"do
    visit root_path
    click_link('Login')

    expect(page).to have_content("Serious la Forgot Password?")
  end

  scenario "user logouts"do
    visit root_path
    click_link('Login')
    fill_in 'email_field', with: @user.email
    fill_in 'password_field', with: @user.password
    click_button('Login')

    visit root_path
    click_link('Logout')

    expect(page).to have_current_path(root_path)
    expect(find('.message').text).to eql("You've been logged out")
  end

end
