require "rails_helper"

RSpec.describe "Artefacts", type: :request do
  let(:user) { create(:user) }
  let(:song) { create(:song, creator: user) }

  before { sign_in(user) }

  describe "GET /songs/:song_id/artefacts/new" do
    it "returns a turbo frame with the artefact form" do
      get new_song_artefact_path(song), headers: { "Turbo-Frame" => "new_artefact_for_song_#{song.id}" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("turbo-frame")
    end

    it "accepts an optional parent_id for child artefacts" do
      parent = create(:artefact, artefactable: song)
      get new_song_artefact_path(song, parent_id: parent.id), headers: { "Turbo-Frame" => "new_artefact_for_artefact_#{parent.id}" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("parent_id")
      expect(response.body).to include(parent.id.to_s)
    end

    it "works with a deeply nested parent artefact" do
      level1 = create(:artefact, artefactable: song)
      level2 = create(:artefact, artefactable: level1)
      get new_song_artefact_path(song, parent_id: level2.id), headers: { "Turbo-Frame" => "new_artefact_for_artefact_#{level2.id}" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /songs/:song_id/artefacts" do
    let(:audio_file) do
      fixture_file_upload(
        Rails.root.join("spec/fixtures/files/test_audio.mp3"),
        "audio/mpeg"
      )
    end

    context "with valid params" do
      it "creates a new artefact" do
        expect {
          post song_artefacts_path(song), params: {
            artefact: { title: "First Mix", audio: audio_file }
          }
        }.to change(Artefact, :count).by(1)
      end

      it "attaches the audio file" do
        post song_artefacts_path(song), params: {
          artefact: { title: "First Mix", audio: audio_file }
        }
        expect(Artefact.last.audio).to be_attached
      end

      it "redirects to the song page for HTML requests" do
        post song_artefacts_path(song), params: {
          artefact: { title: "First Mix", audio: audio_file }
        }
        expect(response).to redirect_to(song_path(song))
      end

      it "responds with turbo_stream when requested" do
        post song_artefacts_path(song), params: {
          artefact: { title: "First Mix" }
        }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "creates artefact without audio file" do
        expect {
          post song_artefacts_path(song), params: {
            artefact: { title: "Placeholder Mix" }
          }
        }.to change(Artefact, :count).by(1)
      end

      it "creates an artefact with a parent" do
        parent = create(:artefact, artefactable: song)
        post song_artefacts_path(song), params: {
          artefact: { title: "Guitar Part", parent_id: parent.id }
        }
        child = Artefact.find_by(title: "Guitar Part")
        expect(child.artefactable).to eq(parent)
      end

      it "creates an artefact with a deeply nested parent" do
        level1 = create(:artefact, artefactable: song)
        level2 = create(:artefact, artefactable: level1)
        post song_artefacts_path(song), params: {
          artefact: { title: "Deep Child", parent_id: level2.id }
        }
        child = Artefact.find_by(title: "Deep Child")
        expect(child.artefactable).to eq(level2)
      end

      it "creates an artefact without a parent" do
        post song_artefacts_path(song), params: {
          artefact: { title: "Standalone Mix" }
        }
        expect(Artefact.last.artefactable).to eq(song)
      end
    end

    context "with invalid params" do
      it "does not create an artefact without a title" do
        expect {
          post song_artefacts_path(song), params: {
            artefact: { title: "" }
          }
        }.not_to change(Artefact, :count)
      end

      it "responds with unprocessable_entity" do
        post song_artefacts_path(song), params: {
          artefact: { title: "" }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /songs/:song_id/artefacts/:id/edit" do
    it "returns a turbo frame with the edit form" do
      artefact = create(:artefact, artefactable: song)
      get edit_song_artefact_path(song, artefact)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("turbo-frame")
      expect(response.body).to include(artefact.title)
    end

    it "works with a deeply nested artefact" do
      level1 = create(:artefact, artefactable: song)
      level2 = create(:artefact, artefactable: level1)
      get edit_song_artefact_path(song, level2)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /songs/:song_id/artefacts/:id" do
    let(:artefact) { create(:artefact, artefactable: song, title: "Original") }

    context "with valid params" do
      it "updates the artefact" do
        patch song_artefact_path(song, artefact), params: { artefact: { title: "Updated" } }
        expect(artefact.reload.title).to eq("Updated")
      end

      it "redirects to the song page for HTML requests" do
        patch song_artefact_path(song, artefact), params: { artefact: { title: "Updated" } }
        expect(response).to redirect_to(song_path(song))
      end

      it "responds with turbo_stream when requested" do
        patch song_artefact_path(song, artefact), params: {
          artefact: { title: "Updated" }
        }, headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "updates a deeply nested artefact" do
        level1 = create(:artefact, artefactable: song)
        level2 = create(:artefact, artefactable: level1, title: "Deep")
        patch song_artefact_path(song, level2), params: { artefact: { title: "Deep Updated" } }
        expect(level2.reload.title).to eq("Deep Updated")
      end
    end

    context "with invalid params" do
      it "does not update the artefact" do
        patch song_artefact_path(song, artefact), params: { artefact: { title: "" } }
        expect(artefact.reload.title).to eq("Original")
      end

      it "responds with unprocessable_entity" do
        patch song_artefact_path(song, artefact), params: { artefact: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /songs/:song_id/artefacts/:id" do
    it "destroys the artefact" do
      artefact = create(:artefact, artefactable: song)
      expect {
        delete song_artefact_path(song, artefact)
      }.to change(Artefact, :count).by(-1)
    end

    it "destroys a deeply nested artefact" do
      level1 = create(:artefact, artefactable: song)
      level2 = create(:artefact, artefactable: level1)
      level3 = create(:artefact, artefactable: level2)
      expect {
        delete song_artefact_path(song, level3)
      }.to change(Artefact, :count).by(-1)
    end

    it "redirects to the song page for HTML requests" do
      artefact = create(:artefact, artefactable: song)
      delete song_artefact_path(song, artefact)
      expect(response).to redirect_to(song_path(song))
    end

    it "responds with turbo_stream when requested" do
      artefact = create(:artefact, artefactable: song)
      delete song_artefact_path(song, artefact), headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end

  context "when not authenticated" do
    before { sign_out }

    it "redirects to login" do
      post song_artefacts_path(song), params: {
        artefact: { title: "Test" }
      }
      expect(response).to redirect_to(login_path)
    end
  end
end
