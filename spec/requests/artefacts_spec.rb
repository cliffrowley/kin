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
            artefact: { title: "First Mix", artefact_type: "mix", audio: audio_file }
          }
        }.to change(Artefact, :count).by(1)
      end

      it "attaches the audio file" do
        post song_artefacts_path(song), params: {
          artefact: { title: "First Mix", artefact_type: "mix", audio: audio_file }
        }
        expect(Artefact.last.audio).to be_attached
      end

      it "redirects to the song page" do
        post song_artefacts_path(song), params: {
          artefact: { title: "First Mix", artefact_type: "mix", audio: audio_file }
        }
        expect(response).to redirect_to(song_path(song))
      end

      it "creates artefact without audio file" do
        expect {
          post song_artefacts_path(song), params: {
            artefact: { title: "Placeholder Mix", artefact_type: "mix" }
          }
        }.to change(Artefact, :count).by(1)
      end

      it "sets the correct artefact type" do
        post song_artefacts_path(song), params: {
          artefact: { title: "Guitar Track", artefact_type: "contribution", audio: audio_file }
        }
        expect(Artefact.last).to be_contribution
      end

      it "creates an artefact with a parent" do
        parent = create(:artefact, song: song, artefact_type: :mix)
        post song_artefacts_path(song), params: {
          artefact: { title: "Guitar Part", artefact_type: "contribution", parent_id: parent.id }
        }
        child = Artefact.find_by(title: "Guitar Part")
        expect(child.parent).to eq(parent)
      end

      it "creates an artefact without a parent" do
        post song_artefacts_path(song), params: {
          artefact: { title: "Standalone Mix", artefact_type: "mix" }
        }
        expect(Artefact.last.parent_id).to be_nil
      end
    end

    context "with invalid params" do
      it "does not create an artefact without a title" do
        expect {
          post song_artefacts_path(song), params: {
            artefact: { title: "", artefact_type: "mix" }
          }
        }.not_to change(Artefact, :count)
      end

      it "does not create an artefact without a type" do
        expect {
          post song_artefacts_path(song), params: {
            artefact: { title: "No Type" }
          }
        }.not_to change(Artefact, :count)
      end

      it "re-renders the song page" do
        post song_artefacts_path(song), params: {
          artefact: { title: "", artefact_type: "mix" }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /songs/:song_id/artefacts/:id" do
    it "destroys the artefact" do
      artefact = create(:artefact, song: song)
      expect {
        delete song_artefact_path(song, artefact)
      }.to change(Artefact, :count).by(-1)
    end

    it "redirects to the song page" do
      artefact = create(:artefact, song: song)
      delete song_artefact_path(song, artefact)
      expect(response).to redirect_to(song_path(song))
    end
  end

  context "when not authenticated" do
    before { sign_out }

    it "redirects to login" do
      post song_artefacts_path(song), params: {
        artefact: { title: "Test", artefact_type: "mix" }
      }
      expect(response).to redirect_to(login_path)
    end
  end
end
