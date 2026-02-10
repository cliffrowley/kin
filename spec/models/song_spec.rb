require "rails_helper"

RSpec.describe Song, type: :model do
  describe "associations" do
    it "belongs to a creator (User)" do
      user = create(:user)
      song = create(:song, creator: user)

      expect(song.creator).to eq(user)
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
