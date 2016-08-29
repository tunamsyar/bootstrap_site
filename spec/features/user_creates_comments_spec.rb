require 'rails_helper'

RSpec.feature "User Creates Comments", type: :feature, js: true do
  before(:all)do
    @user = create(:user)
    @topic = create(:topic)
    @post = create(:post, topic_id: @topic.id, user_id: @user.id)
    @comment = create(:comment, post_id: @post.id, user_id: @user.id)
  end

  def user_login
    visit root_path
    click_link('Login')
    fill_in 'email_field', with: @user.email
    fill_in 'password_field', with: @user.password
    click_button('Login')
    click_button('close')
  end
  
  scenario "user creates comments"do
    user_login

    visit topic_post_comments_path(@topic, @post)

    fill_in 'comment_body_field', with: "new commente"
    click_button("Create comment")

    expect(find('.message').text).to eql("Comment created")
  end

  scenario "user creates posts"do
    user_login
    visit topic_posts_path(@topic)

    fill_in 'post_title_field', with: "new postse"
    fill_in 'post_body_field', with: "nee postedes"
    click_button ('Create post')

    expect(find('.message').text).to eql("You've created a new post.")
  end

  scenario "user cannot create topics" do
    user_login
    click_link('Topics')

    fill_in 'topic_title_field', with: "new otpics"
    fill_in 'topic_description_field', with: "new topititcs"

    click_button('Create Topic')

    expect(find('.message').text).to eql("You're not authorized")
  end

end
