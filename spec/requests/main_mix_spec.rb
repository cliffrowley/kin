require "rails_helper"

RSpec.describe "Main Mix", type: :request do
  let(:user) { create(:user) }
  let(:song) { create(:song, creator: user) }

  before { sign_in(user) }

  describe "PATCH /songs/:song_id/main_mix" do
    context "with a valid mix artefact" do
      it "sets the main mix" do
        mix = create(:artefact, song: song, artefact_type: :mix)
        patch song_main_mix_path(song), params: { artefact_id: mix.id }
        expect(song.reload.main_mix).to eq(mix)
      end

      it "redirects to the song page" do
        mix = create(:artefact, song: song, artefact_type: :mix)
        patch song_main_mix_path(song), params: { artefact_id: mix.id }
        expect(response).to redirect_to(song_path(song))
      end

      it "shows a success notice" do
        mix = create(:artefact, song: song, artefact_type: :mix)
        patch song_main_mix_path(song), params: { artefact_id: mix.id }
        follow_redirect!
        expect(response.body).to include("Main mix updated")
      end
    end

    context "when changing the main mix" do
      it "replaces the previous main mix" do
        old_mix = create(:artefact, song: song, artefact_type: :mix, title: "Old Mix")
        new_mix = create(:artefact, song: song, artefact_type: :mix, title: "New Mix")
        song.update!(main_mix: old_mix)

        patch song_main_mix_path(song), params: { artefact_id: new_mix.id }
        expect(song.reload.main_mix).to eq(new_mix)
      end
    end

    context "with a non-mix artefact" do
      it "does not set the main mix" do
        contribution = create(:artefact, song: song, artefact_type: :contribution)
        patch song_main_mix_path(song), params: { artefact_id: contribution.id }
        expect(song.reload.main_mix).to be_nil
      end

      it "redirects with an error" do
        contribution = create(:artefact, song: song, artefact_type: :contribution)
        patch song_main_mix_path(song), params: { artefact_id: contribution.id }
        expect(response).to redirect_to(song_path(song))
        follow_redirect!
        expect(response.body).to include("must be a mix")
      end
    end
  end

  describe "DELETE /songs/:song_id/main_mix" do
    it "clears the main mix" do
      mix = create(:artefact, song: song, artefact_type: :mix)
      song.update!(main_mix: mix)

      delete song_main_mix_path(song)
      expect(song.reload.main_mix).to be_nil
    end

    it "redirects to the song page" do
      mix = create(:artefact, song: song, artefact_type: :mix)
      song.update!(main_mix: mix)

      delete song_main_mix_path(song)
      expect(response).to redirect_to(song_path(song))
    end
  end

  context "when not authenticated" do
    before { sign_out }

    it "redirects to login" do
      patch song_main_mix_path(song), params: { artefact_id: 1 }
      expect(response).to redirect_to(login_path)
    end
  end
end
