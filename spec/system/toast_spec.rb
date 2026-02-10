require "rails_helper"

RSpec.describe "Toast auto-dismiss", type: :system do
  let!(:user) { create(:user) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: user.provider,
      uid: user.uid,
      info: {
        email: user.email,
        name: user.name
      }
    )
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  context "when JavaScript is enabled", js: true do
    it "auto-dismisses success toast after a few seconds" do
      visit login_path
      click_button "Sign in with Google"

      # Toast should be visible initially
      expect(page).to have_text("Signed in successfully.")

      # Wait for auto-dismiss (3 seconds + fade-out time + buffer)
      expect(page).not_to have_text("Signed in successfully.", wait: 5)
    end

    it "auto-dismisses notice toast after signing out" do
      # Sign in first
      visit login_path
      click_button "Sign in with Google"

      # Wait for the sign-in toast to be fully removed from the DOM
      expect(page).not_to have_css(".toast", wait: 5)

      # Sign out to trigger a toast
      click_button "Sign out"

      # Toast should be visible initially
      expect(page).to have_text("Signed out.")

      # Wait for auto-dismiss (3 seconds + fade-out time + buffer)
      expect(page).not_to have_text("Signed out.", wait: 5)
    end
  end
end
