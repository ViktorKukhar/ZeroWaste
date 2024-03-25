# frozen_string_literal: true

require "rails_helper"

describe "visit Calculator page", js: true do
  let(:user) { create(:user) }
  let(:calculator) { create(:calculator) }

  it "visits calculator page" do
    visit "#{I18n.locale}/calculator"

    expect(page).to have_content "Child’s age"
  end

  it "visits calculator page" do
    visit "#{I18n.locale}/calculator"
    page.driver.browser.manage.window.resize_to(1920, 1080)
  end
end
