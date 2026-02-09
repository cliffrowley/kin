require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "requires an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "requires a unique email" do
      create(:user, email: "taken@example.com")
      user = build(:user, email: "taken@example.com")
      expect(user).not_to be_valid
    end

    it "requires a provider" do
      user = build(:user, provider: nil)
      expect(user).not_to be_valid
    end

    it "requires a uid" do
      user = build(:user, uid: nil)
      expect(user).not_to be_valid
    end

    it "requires a unique uid scoped to provider" do
      create(:user, provider: "google_oauth2", uid: "123")
      user = build(:user, provider: "google_oauth2", uid: "123")
      expect(user).not_to be_valid
    end
  end

  describe ".from_omniauth" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "999888777",
        info: {
          email: "musician@example.com",
          name: "A Musician"
        }
      )
    end

    context "when the user does not exist" do
      it "creates a new user" do
        expect { User.from_omniauth(auth_hash) }.to change(User, :count).by(1)
      end

      it "returns the new user with correct attributes" do
        user = User.from_omniauth(auth_hash)
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("999888777")
        expect(user.email).to eq("musician@example.com")
        expect(user.name).to eq("A Musician")
      end
    end

    context "when the user already exists" do
      let!(:existing_user) do
        create(:user, provider: "google_oauth2", uid: "999888777", email: "old@example.com", name: "Old Name")
      end

      it "does not create a new user" do
        expect { User.from_omniauth(auth_hash) }.not_to change(User, :count)
      end

      it "updates the user's name and email" do
        user = User.from_omniauth(auth_hash)
        expect(user.email).to eq("musician@example.com")
        expect(user.name).to eq("A Musician")
      end
    end
  end
end
