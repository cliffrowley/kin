require "rails_helper"

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:song) { create(:song, creator: user) }

  before { sign_in(user) }

  describe "POST /songs/:song_id/comments (song-level)" do
    context "with valid params" do
      it "creates a comment on the song" do
        expect {
          post song_comments_path(song), params: { comment: { body: "Great song!" } }
        }.to change(Comment, :count).by(1)
      end

      it "assigns the current user as author" do
        post song_comments_path(song), params: { comment: { body: "Great song!" } }
        expect(Comment.last.user).to eq(user)
      end

      it "associates the comment with the song" do
        post song_comments_path(song), params: { comment: { body: "Great song!" } }
        comment = Comment.last
        expect(comment.commentable).to eq(song)
      end

      it "redirects to the song page" do
        post song_comments_path(song), params: { comment: { body: "Great song!" } }
        expect(response).to redirect_to(song_path(song))
      end
    end

    context "with invalid params" do
      it "does not create a comment without a body" do
        expect {
          post song_comments_path(song), params: { comment: { body: "" } }
        }.not_to change(Comment, :count)
      end

      it "redirects to the song page with an alert" do
        post song_comments_path(song), params: { comment: { body: "" } }
        expect(response).to redirect_to(song_path(song))
      end
    end
  end

  describe "POST /songs/:song_id/artefacts/:artefact_id/comments (artefact-level)" do
    let(:artefact) { create(:artefact, song: song) }

    context "with valid params" do
      it "creates a comment on the artefact" do
        expect {
          post song_artefact_comments_path(song, artefact), params: { comment: { body: "Nice mix!" } }
        }.to change(Comment, :count).by(1)
      end

      it "assigns the current user as author" do
        post song_artefact_comments_path(song, artefact), params: { comment: { body: "Nice mix!" } }
        expect(Comment.last.user).to eq(user)
      end

      it "associates the comment with the artefact" do
        post song_artefact_comments_path(song, artefact), params: { comment: { body: "Nice mix!" } }
        comment = Comment.last
        expect(comment.commentable).to eq(artefact)
      end

      it "redirects to the song page" do
        post song_artefact_comments_path(song, artefact), params: { comment: { body: "Nice mix!" } }
        expect(response).to redirect_to(song_path(song))
      end
    end

    context "with invalid params" do
      it "does not create a comment without a body" do
        expect {
          post song_artefact_comments_path(song, artefact), params: { comment: { body: "" } }
        }.not_to change(Comment, :count)
      end
    end
  end

  describe "DELETE /songs/:song_id/comments/:id" do
    it "destroys the comment" do
      comment = create(:comment, commentable: song, user: user)
      expect {
        delete song_comment_path(song, comment)
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the song page" do
      comment = create(:comment, commentable: song, user: user)
      delete song_comment_path(song, comment)
      expect(response).to redirect_to(song_path(song))
    end

    it "does not allow deleting another user's comment" do
      other_user = create(:user)
      comment = create(:comment, commentable: song, user: other_user)
      expect {
        delete song_comment_path(song, comment)
      }.not_to change(Comment, :count)
    end
  end

  context "when not authenticated" do
    before { sign_out }

    it "redirects to login for song comments" do
      post song_comments_path(song), params: { comment: { body: "Test" } }
      expect(response).to redirect_to(login_path)
    end
  end
end
