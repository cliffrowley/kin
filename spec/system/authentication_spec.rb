require "rails_helper"

RSpec.describe "Authentication", type: :system do
  before do
    driven_by(:rack_test)
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  describe "signing in" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456",
        info: {
          email: "musician@example.com",
          name: "A Musician"
        }
      )
    end

    it "allows a user to sign in with Google" do
      visit login_path
      click_button "Sign in with Google"

      expect(page).to have_text("A Musician")
      expect(page).to have_button("Sign out")
    end
  end

  describe "signing out" do
    let!(:user) { create(:user, name: "A Musician") }

    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: user.provider,
        uid: user.uid,
        info: {
          email: user.email,
          name: user.name
        }
      )
    end

    it "allows a user to sign out" do
      visit login_path
      click_button "Sign in with Google"

      click_button "Sign out"

      expect(page).to have_button("Sign in with Google")
      expect(page).not_to have_text("A Musician")
    end
  end

  describe "accessing protected pages" do
    it "redirects unauthenticated users to the login page" do
      # Once there are protected pages (e.g. songs), this will
      # verify the redirect. For now, root is the login page.
      visit root_path
      expect(page).to have_button("Sign in with Google")
    end
  end
end
