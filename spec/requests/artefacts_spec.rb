require "rails_helper"

RSpec.describe "Artefacts", type: :request do
  let(:user) { create(:user) }
  let(:song) { create(:song, creator: user) }

  before { sign_in(user) }

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

      it "redirects to the song page" do
        post song_artefacts_path(song), params: {
          artefact: { title: "First Mix", audio: audio_file }
        }
        expect(response).to redirect_to(song_path(song))
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

      it "re-renders the song page" do
        post song_artefacts_path(song), params: {
          artefact: { title: "" }
        }
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

    it "redirects to the song page" do
      artefact = create(:artefact, artefactable: song)
      delete song_artefact_path(song, artefact)
      expect(response).to redirect_to(song_path(song))
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
