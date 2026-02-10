require "rails_helper"

RSpec.describe Song, type: :model do
  describe "associations" do
    it "belongs to a creator (User)" do
      user = create(:user)
      song = create(:song, creator: user)

      expect(song.creator).to eq(user)
    end

    it "has many artefacts" do
      song = create(:song)
      create(:artefact, song: song)
      create(:artefact, song: song)

      expect(song.artefacts.count).to eq(2)
    end

    it "destroys artefacts when destroyed" do
      song = create(:song)
      create(:artefact, song: song)

      expect { song.destroy }.to change(Artefact, :count).by(-1)
    end

    it "has an optional main_mix reference to an artefact" do
      song = create(:song)
      expect(song.main_mix).to be_nil
    end

    it "can have a main mix set" do
      song = create(:song)
      mix = create(:artefact, song: song)
      song.update!(main_mix: mix)
      expect(song.reload.main_mix).to eq(mix)
    end

    it "nullifies main_mix when the artefact is destroyed" do
      song = create(:song)
      mix = create(:artefact, song: song)
      song.update!(main_mix: mix)
      mix.destroy
      expect(song.reload.main_mix).to be_nil
    end
  end

  describe "validations" do
    it "is valid with a title and creator" do
      song = build(:song)
      expect(song).to be_valid
    end

    it "is invalid without a title" do
      song = build(:song, title: nil)
      expect(song).not_to be_valid
      expect(song.errors[:title]).to include("can't be blank")
    end

    it "is invalid without a creator" do
      song = build(:song, creator: nil)
      expect(song).not_to be_valid
    end

    it "is invalid if main_mix does not belong to the song" do
      song = create(:song)
      other_song = create(:song, creator: create(:user))
      mix = create(:artefact, song: other_song)
      song.main_mix = mix
      expect(song).not_to be_valid
      expect(song.errors[:main_mix]).to include("must belong to this song")
    end
  end

  describe "metadata fields" do
    it "accepts a key" do
      song = create(:song, key: "Am")
      expect(song.reload.key).to eq("Am")
    end

    it "accepts a tempo" do
      song = create(:song, tempo: 120)
      expect(song.reload.tempo).to eq(120)
    end

    it "accepts lyrics" do
      song = create(:song, lyrics: "Hello world\nSecond line")
      expect(song.reload.lyrics).to eq("Hello world\nSecond line")
    end

    it "allows all metadata fields to be nil" do
      song = build(:song, key: nil, tempo: nil, lyrics: nil)
      expect(song).to be_valid
    end

    it "is invalid if tempo is not a number" do
      song = build(:song, tempo: "fast")
      expect(song).not_to be_valid
      expect(song.errors[:tempo]).to include("is not a number")
    end

    it "is invalid if tempo is zero" do
      song = build(:song, tempo: 0)
      expect(song).not_to be_valid
      expect(song.errors[:tempo]).to include("must be greater than 0")
    end

    it "is invalid if tempo is negative" do
      song = build(:song, tempo: -10)
      expect(song).not_to be_valid
      expect(song.errors[:tempo]).to include("must be greater than 0")
    end

    it "allows decimal tempo values" do
      song = create(:song, tempo: 128.5)
      expect(song.reload.tempo).to eq(128.5)
    end
  end

  describe "default scope" do
    it "orders by most recently updated first" do
      user = create(:user)
      old_song = create(:song, title: "Old", creator: user)
      new_song = create(:song, title: "New", creator: user)

      old_song.update!(updated_at: 2.days.ago)
      new_song.update!(updated_at: 1.hour.ago)

      expect(Song.all.to_a).to eq([ new_song, old_song ])
    end
  end
end
