require 'rails_helper'

RSpec.feature "User Management", type: :feature, js:true do

  before(:all)do
    @user = create :user
  end

  scenario "new user registration"do
    visit root_path
    click_link('Register')

    fill_in 'username_field', with: "jerry christ"
    fill_in 'email_field', with: "jc@mail.com"
    fill_in 'password_field', with: "password"
    fill_in 'password_confirmation_field', with: "password"

    click_button('Create Login')

    expect(find('.message').text).to eql("New User created")
    expect(User.count).to eql(2)
  end

  scenario "registration error"do
    visit root_path
    click_link('Register')

    fill_in 'username_field', with: "walauwei"
    fill_in 'password_field', with: "password"
    fill_in 'password_confirmation_field', with: "password1"

    click_button('Create Login')

    expect(find('.message').text).to eql("Passwords do not match!")
    expect(User.count).to eql(2)
  end

  scenario "user updates password"do
    visit root_path
    click_link('Login')

    fill_in 'email_field', with: @user.email
    fill_in 'password_field', with: @user.password
    click_button('Login')
    click_button('close')
    click_link('My Account')

    fill_in 'password_field', with: "password1"
    fill_in 'password_confirmation_field', with: "password1"
    click_button('Update Account')

    expect(find('.message').text).to eql("Account Updated")
  end

end
