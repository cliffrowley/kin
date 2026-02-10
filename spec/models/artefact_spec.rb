require "rails_helper"

RSpec.describe Artefact, type: :model do
  describe "associations" do
    it "belongs to a song via artefactable" do
      song = create(:song)
      artefact = create(:artefact, artefactable: song)
      expect(artefact.artefactable).to eq(song)
      expect(artefact.song).to eq(song)
    end

    it "has one attached audio" do
      artefact = create(:artefact)
      expect(artefact).to respond_to(:audio)
    end

    it "can belong to a parent artefact" do
      song = create(:song)
      parent = create(:artefact, artefactable: song)
      child = create(:artefact, artefactable: parent)
      expect(child.artefactable).to eq(parent)
      expect(child.parent).to eq(parent)
    end

    it "has many child artefacts" do
      song = create(:song)
      parent = create(:artefact, artefactable: song)
      child1 = create(:artefact, artefactable: parent)
      child2 = create(:artefact, artefactable: parent)
      expect(parent.artefacts).to contain_exactly(child1, child2)
      expect(parent.children).to contain_exactly(child1, child2)
    end

    it "destroys children when parent is destroyed" do
      song = create(:song)
      parent = create(:artefact, artefactable: song)
      _child = create(:artefact, artefactable: parent)
      expect { parent.destroy }.to change(Artefact, :count).by(-2)
    end

    it "walks up the chain to find the song" do
      song = create(:song)
      parent = create(:artefact, artefactable: song)
      child = create(:artefact, artefactable: parent)
      expect(child.song).to eq(song)
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

    it "requires an artefactable" do
      artefact = build(:artefact, artefactable: nil)
      expect(artefact).not_to be_valid
    end
  end

  describe "scoping" do
    it "orders by created_at descending by default" do
      song = create(:song)
      older = create(:artefact, artefactable: song, created_at: 2.days.ago)
      newer = create(:artefact, artefactable: song, created_at: 1.day.ago)
      expect(song.artefacts).to eq([ newer, older ])
    end

    it "scopes top_level to artefacts owned by a Song" do
      song = create(:song)
      parent = create(:artefact, artefactable: song)
      _child = create(:artefact, artefactable: parent)
      expect(Artefact.top_level).to include(parent)
      expect(Artefact.top_level).not_to include(_child)
    end
  end
end
