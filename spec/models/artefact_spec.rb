require "rails_helper"

RSpec.describe Artefact, type: :model do
  describe "associations" do
    it "belongs to a song" do
      artefact = create(:artefact)
      expect(artefact.song).to be_a(Song)
    end

    it "has one attached audio" do
      artefact = create(:artefact)
      expect(artefact).to respond_to(:audio)
    end

    it "optionally belongs to a parent artefact" do
      song = create(:song)
      parent = create(:artefact, song: song)
      child = create(:artefact, song: song, parent: parent)
      expect(child.parent).to eq(parent)
    end

    it "has many children artefacts" do
      song = create(:song)
      parent = create(:artefact, song: song)
      child1 = create(:artefact, song: song, parent: parent)
      child2 = create(:artefact, song: song, parent: parent)
      expect(parent.children).to contain_exactly(child1, child2)
    end

    it "nullifies children when parent is destroyed" do
      song = create(:song)
      parent = create(:artefact, song: song)
      child = create(:artefact, song: song, parent: parent)
      parent.destroy
      expect(child.reload.parent_id).to be_nil
    end

    it "is valid without a parent" do
      artefact = build(:artefact, parent: nil)
      expect(artefact).to be_valid
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      artefact = build(:artefact)
      expect(artefact).to be_valid
    end

    it "requires a title" do
      artefact = build(:artefact, title: nil)
      expect(artefact).not_to be_valid
      expect(artefact.errors[:title]).to include("can't be blank")
    end

    it "requires a song" do
      artefact = build(:artefact, song: nil)
      expect(artefact).not_to be_valid
    end

    it "is invalid if parent belongs to a different song" do
      song1 = create(:song)
      song2 = create(:song)
      parent = create(:artefact, song: song1)
      child = build(:artefact, song: song2, parent: parent)
      expect(child).not_to be_valid
      expect(child.errors[:parent]).to include("must belong to the same song")
    end

    it "is valid if parent belongs to the same song" do
      song = create(:song)
      parent = create(:artefact, song: song)
      child = build(:artefact, song: song, parent: parent)
      expect(child).to be_valid
    end
  end

  describe "scoping" do
    it "orders by created_at descending by default" do
      song = create(:song)
      older = create(:artefact, song: song, created_at: 2.days.ago)
      newer = create(:artefact, song: song, created_at: 1.day.ago)
      expect(song.artefacts).to eq([ newer, older ])
    end

    it "scopes top_level to artefacts without a parent" do
      song = create(:song)
      parent = create(:artefact, song: song)
      child = create(:artefact, song: song, parent: parent)
      expect(song.artefacts.top_level).to include(parent)
      expect(song.artefacts.top_level).not_to include(child)
    end
  end
end
