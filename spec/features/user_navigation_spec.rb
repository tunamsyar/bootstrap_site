require 'rails_helper'

RSpec.feature "User Navigation", type: :feature, js:true do
  before(:all)do
    @user = create(:user)
    @topic = create(:topic)
    @post = create(:post, topic_id: @topic.id, user_id: @user.id)
    @comment = create(:comment, post_id: @post.id, user_id: @user.id)
  end

  scenario "navigate to comment"do
      visit root_path
      click_link('Login')

      fill_in 'email_field', with: @user.email
      fill_in 'password_field', with: @user.password
      click_button('Login')
      click_button('close')

      click_link('Topics')
      click_link(@topic.title)
      click_link(@post.title)
      
      expect(page).to have_current_path(topic_post_comments_path(@topic, @post))
  end

end
