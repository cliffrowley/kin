require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it "belongs to a user" do
      comment = create(:comment)
      expect(comment.user).to be_a(User)
    end

    it "belongs to a commentable (artefact)" do
      artefact = create(:artefact)
      comment = create(:comment, commentable: artefact)
      expect(comment.commentable).to eq(artefact)
    end

    it "belongs to a commentable (song)" do
      song = create(:song)
      comment = create(:comment, commentable: song)
      expect(comment.commentable).to eq(song)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it "requires a body" do
      comment = build(:comment, body: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("can't be blank")
    end

    it "requires a body that is not blank" do
      comment = build(:comment, body: "   ")
      expect(comment).not_to be_valid
    end

    it "requires a user" do
      comment = build(:comment, user: nil)
      expect(comment).not_to be_valid
    end

    it "requires a commentable" do
      comment = build(:comment, commentable: nil)
      expect(comment).not_to be_valid
    end
  end

  describe "scoping" do
    it "orders by created_at ascending (oldest first)" do
      artefact = create(:artefact)
      older = create(:comment, commentable: artefact, created_at: 2.days.ago)
      newer = create(:comment, commentable: artefact, created_at: 1.day.ago)
      expect(artefact.comments.to_a).to eq([ older, newer ])
    end
  end

  describe "dependent destroy" do
    it "is destroyed when its commentable artefact is destroyed" do
      artefact = create(:artefact)
      create(:comment, commentable: artefact)
      expect { artefact.destroy }.to change(Comment, :count).by(-1)
    end

    it "is destroyed when its commentable song is destroyed" do
      song = create(:song)
      create(:comment, commentable: song)
      expect { song.destroy }.to change(Comment, :count).by(-1)
    end
  end
end
