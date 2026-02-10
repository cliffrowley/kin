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

    it "requires an artefact_type" do
      artefact = build(:artefact, artefact_type: nil)
      expect(artefact).not_to be_valid
      expect(artefact.errors[:artefact_type]).to include("can't be blank")
    end

    it "requires a song" do
      artefact = build(:artefact, song: nil)
      expect(artefact).not_to be_valid
    end
  end

  describe "enum" do
    it "defines artefact_type enum with mix, contribution, and master" do
      expect(Artefact.artefact_types).to eq("mix" => 0, "contribution" => 1, "master" => 2)
    end

    it "can be a mix" do
      artefact = build(:artefact, artefact_type: :mix)
      expect(artefact).to be_mix
    end

    it "can be a contribution" do
      artefact = build(:artefact, artefact_type: :contribution)
      expect(artefact).to be_contribution
    end

    it "can be a master" do
      artefact = build(:artefact, artefact_type: :master)
      expect(artefact).to be_master
    end
  end

  describe "scoping" do
    it "orders by created_at descending by default" do
      song = create(:song)
      older = create(:artefact, song: song, created_at: 2.days.ago)
      newer = create(:artefact, song: song, created_at: 1.day.ago)
      expect(song.artefacts).to eq([ newer, older ])
    end
  end
end
