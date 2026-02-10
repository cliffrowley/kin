require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user, provider: nil, uid: nil)
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

    it "requires a name" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end

    it "does not require a provider" do
      user = build(:user, provider: nil)
      expect(user).to be_valid
    end

    it "does not require a uid" do
      user = build(:user, uid: nil)
      expect(user).to be_valid
    end

    it "requires a unique uid scoped to provider when present" do
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

    context "when a user with the email exists" do
      let!(:existing_user) do
        create(:user, email: "musician@example.com", name: "Old Name", provider: nil, uid: nil)
      end

      it "does not create a new user" do
        expect { User.from_omniauth(auth_hash) }.not_to change(User, :count)
      end

      it "returns the existing user with updated OAuth attributes" do
        user = User.from_omniauth(auth_hash)
        expect(user.id).to eq(existing_user.id)
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("999888777")
        expect(user.name).to eq("A Musician")
      end
    end

    context "when no user with the email exists" do
      it "returns nil" do
        expect(User.from_omniauth(auth_hash)).to be_nil
      end

      it "does not create a user" do
        expect { User.from_omniauth(auth_hash) }.not_to change(User, :count)
      end
    end
  end
end
