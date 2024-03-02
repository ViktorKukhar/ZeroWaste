# frozen_string_literal: true

require "rails_helper"

describe "visit Calculator page", js: true do
  let(:user) { create(:user) }
  let(:calculator) { create(:calculator) }

  it "visits calculator page" do
    visit "#{I18n.locale}/calculator"

    expect(page).to have_content "Child’s age"
  end

  it "visits calculator page and open log_in page" do
    visit "#{I18n.locale}/calculator"
    find(".admin-menu-burger-button").click
    click_on("Log In")

    expect(page).to have_content "Forgot your password"
  end
end
