include ActionDispatch::TestProcess


FactoryGirl.define do
  factory :comment do
    body "new commentes"
    post_id {create(:post).id}
    user_id {create(:user, :sequenced_username, :sequenced_email).id}

    trait :with_image do
      image { fixture_file_upload("#{::Rails.root}/spec/fixtures/rick.jpg") }
    end

    trait :with_user do
      user_id { create(:user).id }
    end

    trait :with_post do
      post_id { create(:post).id }
    end

    trait :sequenced_body do
      body
    end
  end
end
