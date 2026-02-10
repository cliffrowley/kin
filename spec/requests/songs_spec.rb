require "rails_helper"

RSpec.describe "Songs", type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "GET /songs" do
    it "returns a successful response" do
      get songs_path
      expect(response).to have_http_status(:ok)
    end

    it "displays songs" do
      song = create(:song, title: "Highway Star", creator: user)
      get songs_path
      expect(response.body).to include("Highway Star")
    end
  end

  describe "GET /songs/:id" do
    it "returns a successful response" do
      song = create(:song, creator: user)
      get song_path(song)
      expect(response).to have_http_status(:ok)
    end

    it "displays the song details" do
      song = create(:song, title: "Smoke on the Water", notes: "Classic riff", creator: user)
      get song_path(song)
      expect(response.body).to include("Smoke on the Water")
      expect(response.body).to include("Classic riff")
    end

    it "displays song metadata when present" do
      song = create(:song, title: "Riff Song", key: "Am", tempo: 120, lyrics: "La la la", creator: user)
      get song_path(song)
      expect(response.body).to include("Am")
      expect(response.body).to include("120")
      expect(response.body).to include("La la la")
    end
  end

  describe "GET /songs/new" do
    it "returns a successful response" do
      get new_song_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /songs" do
    context "with valid params" do
      it "creates a new song" do
        expect {
          post songs_path, params: { song: { title: "New Song", notes: "Some notes" } }
        }.to change(Song, :count).by(1)
      end

      it "creates a song with metadata" do
        post songs_path, params: { song: { title: "Jam", key: "Dm", tempo: 95, lyrics: "Words" } }
        song = Song.last
        expect(song.key).to eq("Dm")
        expect(song.tempo).to eq(95)
        expect(song.lyrics).to eq("Words")
      end

      it "assigns the current user as creator" do
        post songs_path, params: { song: { title: "New Song" } }
        expect(Song.last.creator).to eq(user)
      end

      it "redirects to the song" do
        post songs_path, params: { song: { title: "New Song" } }
        expect(response).to redirect_to(song_path(Song.last))
      end
    end

    context "with invalid params" do
      it "does not create a song" do
        expect {
          post songs_path, params: { song: { title: "" } }
        }.not_to change(Song, :count)
      end

      it "renders the new form" do
        post songs_path, params: { song: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /songs/:id/edit" do
    it "returns a successful response" do
      song = create(:song, creator: user)
      get edit_song_path(song)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /songs/:id" do
    let(:song) { create(:song, title: "Old Title", creator: user) }

    context "with valid params" do
      it "updates the song" do
        patch song_path(song), params: { song: { title: "New Title" } }
        expect(song.reload.title).to eq("New Title")
      end

      it "updates the song metadata" do
        patch song_path(song), params: { song: { key: "Em", tempo: 140, lyrics: "Some lyrics" } }
        song.reload
        expect(song.key).to eq("Em")
        expect(song.tempo).to eq(140)
        expect(song.lyrics).to eq("Some lyrics")
      end

      it "redirects to the song" do
        patch song_path(song), params: { song: { title: "New Title" } }
        expect(response).to redirect_to(song_path(song))
      end
    end

    context "with invalid params" do
      it "does not update the song" do
        patch song_path(song), params: { song: { title: "" } }
        expect(song.reload.title).to eq("Old Title")
      end

      it "renders the edit form" do
        patch song_path(song), params: { song: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /songs/:id" do
    it "destroys the song" do
      song = create(:song, creator: user)
      expect {
        delete song_path(song)
      }.to change(Song, :count).by(-1)
    end

    it "redirects to the songs index" do
      song = create(:song, creator: user)
      delete song_path(song)
      expect(response).to redirect_to(songs_path)
    end
  end

  context "when not authenticated" do
    before { sign_out }

    it "redirects to login" do
      get songs_path
      expect(response).to redirect_to(login_path)
    end
  end
end
