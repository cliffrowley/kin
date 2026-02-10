require "rails_helper"

RSpec.describe "Global audio player", type: :system, js: true do
  let!(:user) { create(:user) }
  let!(:song) { create(:song, creator: user) }
  let!(:artefact) do
    create(:artefact, title: "Main Mix", artefactable: song).tap do |a|
      a.audio.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test_audio.mp3")),
        filename: "test_audio.mp3",
        content_type: "audio/mpeg"
      )
    end
  end

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: user.provider,
      uid: user.uid,
      info: { email: user.email, name: user.name }
    )
    visit login_path
    click_button "Sign in with Google"
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  it "shows the global player bar when a play button is clicked" do
    visit song_path(song)

    # Player bar should be hidden initially
    expect(page).not_to have_css("#global-player:not(.hidden)")

    # Click the play button on the artefact
    find("[data-action='click->play-button#play']", match: :first).click

    # Player bar should become visible
    expect(page).to have_css("#global-player:not(.hidden)")

    # Player should show the artefact title
    expect(find("#global-player")).to have_text("Main Mix")
  end

  it "has play buttons instead of inline audio elements" do
    visit song_path(song)

    # Should not have inline audio elements
    expect(page).not_to have_css("audio[controls]")

    # Should have play buttons for artefacts with audio
    expect(page).to have_css("[data-action='click->play-button#play']")
  end

  it "persists playback across page navigation" do
    visit song_path(song)

    # Start playback
    find("[data-action='click->play-button#play']", match: :first).click

    # Player should be visible
    expect(page).to have_css("#global-player:not(.hidden)")
    expect(find("#global-player")).to have_text("Main Mix")

    # Navigate to another page
    click_link "Songs"

    # Player should still be visible after navigation
    expect(page).to have_css("#global-player:not(.hidden)")
    expect(find("#global-player")).to have_text("Main Mix")
  end

  it "shows a play/pause toggle button in the player" do
    visit song_path(song)

    find("[data-action='click->play-button#play']", match: :first).click

    within("#global-player") do
      expect(page).to have_css("[data-player-target='playPauseButton']")
    end
  end
end
