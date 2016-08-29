FactoryGirl.define do
  sequence :title do |n|
    "title-#{n}"
  end

  sequence :description do |n|
    "description-#{n}"
  end

  sequence :body do |n|
    "super-heavy-body-#{n}"
  end
end
