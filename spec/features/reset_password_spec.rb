# frozen_string_literal: true

require "rails_helper"
PASSWORD_RESET_PATH = "/users/password/new"

describe "Password Reset Page", js: true do
  let(:user) { create(:user) }

  context "when user clicks button Send me reset password instructions" do
    it "shows message that user will receive reset password instructions" do
      skip "Skip test after delete device path"

      receive(:reset_password_instructions)
        .and_return(double(deliver: true))
      visit PASSWORD_RESET_PATH
      fill_in "Email", with: user.email
      click_button "Send me reset password instructions"
      expect(page).to have_content("If your email address exists")
    end
  end

  context "when user clicks Log in link" do
    it "redirect to sign in page" do
      skip "Skip test after delete device path"

      visit PASSWORD_RESET_PATH
      click_on "Log In"
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  context "when user clicks Sign up link" do
    it "redirect to sign up page" do
      skip "Skip test after delete device path"

      visit PASSWORD_RESET_PATH
      click_on "Sign Up"
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end
