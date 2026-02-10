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

    it "shows the moon icon when the effective theme is dark" do
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Dark']").click

      expect(page).to have_css("[data-theme-target='iconDark']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconLight'].hidden", visible: :hidden)
    end

    it "shows the sun icon when the effective theme is light" do
      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Light']").click

      expect(page).to have_css("[data-theme-target='iconLight']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconDark'].hidden", visible: :hidden)
    end

    it "shows the moon icon when system theme is active and OS prefers dark" do
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "dark" } ])
      page.execute_script("localStorage.removeItem('kin-theme')")
      visit current_path

      expect(page).to have_css("[data-theme-target='iconDark']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconLight'].hidden", visible: :hidden)
    end

    it "shows the sun icon when system theme is active and OS prefers light" do
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "light" } ])
      page.execute_script("localStorage.removeItem('kin-theme')")
      visit current_path

      expect(page).to have_css("[data-theme-target='iconLight']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconDark'].hidden", visible: :hidden)
    end

    it "updates the icon in real time when the OS theme changes while system theme is active" do
      # Ensure system theme is active
      page.execute_script("localStorage.removeItem('kin-theme')")

      # Start with OS preferring light
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "light" } ])
      visit current_path

      expect(page).to have_css("[data-theme-target='iconLight']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconDark'].hidden", visible: :hidden)

      # Simulate OS switching to dark — the listener should update the icon automatically
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "dark" } ])

      expect(page).to have_css("[data-theme-target='iconDark']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconLight'].hidden", visible: :hidden)
    end

    it "does not update the icon when OS theme changes if an explicit theme is selected" do
      # Set OS to light, then explicitly choose dark theme
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "light" } ])
      page.execute_script("localStorage.removeItem('kin-theme')")
      visit current_path

      find("[data-controller='theme'] [role='button']").click
      find("input[aria-label='Dark']").click

      expect(page).to have_css("[data-theme-target='iconDark']:not(.hidden)")

      # OS switches to light — icon should stay on moon because explicit dark is selected
      page.driver.browser.execute_cdp("Emulation.setEmulatedMedia", features: [ { name: "prefers-color-scheme", value: "light" } ])

      # Give a moment for any (incorrect) listener to fire
      sleep 0.3
      expect(page).to have_css("[data-theme-target='iconDark']:not(.hidden)")
      expect(page).to have_css("[data-theme-target='iconLight'].hidden", visible: :hidden)
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
