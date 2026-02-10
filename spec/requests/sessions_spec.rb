require "rails_helper"

RSpec.describe "Sessions", type: :request do
  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  describe "GET /auth/google_oauth2/callback" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456",
        info: {
          email: "musician@example.com",
          name: "A Musician"
        }
      )
    end

    before do
      OmniAuth.config.mock_auth[:google_oauth2] = auth_hash
    end

    context "when a user with the email exists" do
      let!(:user) { create(:user, email: "musician@example.com", name: "Old Name", provider: nil, uid: nil) }

      it "does not create a new user" do
        expect { post "/auth/google_oauth2/callback" }.not_to change(User, :count)
      end

      it "sets the user_id in the session" do
        post "/auth/google_oauth2/callback"
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to the root path" do
        post "/auth/google_oauth2/callback"
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user with the email exists" do
      it "does not create a user" do
        expect { post "/auth/google_oauth2/callback" }.not_to change(User, :count)
      end

      it "does not set user_id in the session" do
        post "/auth/google_oauth2/callback"
        expect(session[:user_id]).to be_nil
      end

      it "redirects to the login page with an alert" do
        post "/auth/google_oauth2/callback"
        expect(response).to redirect_to(login_path)
        follow_redirect!
        expect(response.body).to include("not authorised")
      end
    end
  end

  describe "GET /auth/failure" do
    it "redirects to the login page with an alert" do
      get "/auth/failure", params: { message: "access_denied" }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "DELETE /logout" do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it "clears the session" do
      delete "/logout"
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the login page" do
      delete "/logout"
      expect(response).to redirect_to(login_path)
    end
  end
end
