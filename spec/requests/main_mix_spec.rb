require "rails_helper"

RSpec.describe "Main Artefact", type: :request do
  let(:user) { create(:user) }
  let(:song) { create(:song, creator: user) }

  before { sign_in(user) }

  describe "PATCH /songs/:song_id/main_artefact" do
    context "with a valid artefact" do
      it "sets the main artefact" do
        mix = create(:artefact, artefactable: song)
        patch song_main_artefact_path(song), params: { artefact_id: mix.id }
        expect(song.reload.main_artefact).to eq(mix)
      end

      it "redirects to the song page" do
        mix = create(:artefact, artefactable: song)
        patch song_main_artefact_path(song), params: { artefact_id: mix.id }
        expect(response).to redirect_to(song_path(song))
      end

      it "shows a success notice" do
        mix = create(:artefact, artefactable: song)
        patch song_main_artefact_path(song), params: { artefact_id: mix.id }
        follow_redirect!
        expect(response.body).to include("Main artefact updated")
      end
    end

    context "when changing the main artefact" do
      it "replaces the previous main artefact" do
        old_mix = create(:artefact, artefactable: song, title: "Old Mix")
        new_mix = create(:artefact, artefactable: song, title: "New Mix")
        song.update!(main_artefact: old_mix)

        patch song_main_artefact_path(song), params: { artefact_id: new_mix.id }
        expect(song.reload.main_artefact).to eq(new_mix)
      end
    end
  end

  describe "DELETE /songs/:song_id/main_artefact" do
    it "clears the main artefact" do
      mix = create(:artefact, artefactable: song)
      song.update!(main_artefact: mix)

      delete song_main_artefact_path(song)
      expect(song.reload.main_artefact).to be_nil
    end

    it "redirects to the song page" do
      mix = create(:artefact, artefactable: song)
      song.update!(main_artefact: mix)

      delete song_main_artefact_path(song)
      expect(response).to redirect_to(song_path(song))
    end
  end

  context "when not authenticated" do
    before { sign_out }

    it "redirects to login" do
      patch song_main_artefact_path(song), params: { artefact_id: 1 }
      expect(response).to redirect_to(login_path)
    end
  end
end
