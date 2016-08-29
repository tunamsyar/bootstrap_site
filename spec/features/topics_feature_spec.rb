require 'rails_helper'

RSpec.feature "Topics", type: :feature, js: true do
  before(:all)do
    4.times { create(:topic, :sequenced_title, :sequenced_description)}
  end

  scenario "Users visits topic" do
    visit topics_path
    expect(page).to have_selector('.topics_child', count: 4)

  end
end
