require "rails_helper"

RSpec.describe "Theme switcher", type: :system do
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

  context "when logged in", js: true do
    before do
      visit login_path
      click_button "Sign in with Google"
      expect(page).to have_text("KIN") # wait for page load
    end

    it "displays a theme dropdown in the navbar" do
      expect(page).to have_css("[data-controller='theme']")
    end

    it "defaults to system theme (no data-theme attribute)" do
      html = find("html")
      expect(html["data-theme"]).to be_nil
    end

    it "switches to dark theme when selected" do
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Dark']").click

      html = find("html")
      expect(html["data-theme"]).to eq("dark")
    end

    it "switches to light theme when selected" do
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Light']").click

      html = find("html")
      expect(html["data-theme"]).to eq("light")
    end

    it "can switch back to system theme" do
      # First switch to dark
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Dark']").click
      expect(find("html")["data-theme"]).to eq("dark")

      # Then switch back to system
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='System']").click

      html = find("html")
      expect(html["data-theme"]).to be_nil
    end

    it "persists the selected theme across page navigations" do
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Light']").click

      click_link "Songs"
      expect(page).to have_current_path(songs_path)

      html = find("html")
      expect(html["data-theme"]).to eq("light")
    end
  end
end
