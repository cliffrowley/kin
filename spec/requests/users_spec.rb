require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe "GET /users" do
    it "returns a successful response" do
      get "/users"
      expect(response).to have_http_status(:ok)
    end

    it "lists all users" do
      create(:user, name: "Alice", email: "alice@example.com")
      create(:user, name: "Bob", email: "bob@example.com")
      get "/users"
      expect(response.body).to include("Alice")
      expect(response.body).to include("Bob")
    end
  end

  describe "GET /users/new" do
    it "returns a successful response" do
      get "/users/new"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post "/users", params: { user: { name: "New User", email: "newuser@example.com" } }
        }.to change(User, :count).by(1)
      end

      it "redirects to the users list" do
        post "/users", params: { user: { name: "New User", email: "newuser@example.com" } }
        expect(response).to redirect_to(users_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a user" do
        expect {
          post "/users", params: { user: { name: "", email: "" } }
        }.not_to change(User, :count)
      end

      it "renders the new form" do
        post "/users", params: { user: { name: "", email: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /users/:id/edit" do
    let(:target_user) { create(:user) }

    it "returns a successful response" do
      get "/users/#{target_user.id}/edit"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /users/:id" do
    let(:target_user) { create(:user) }

    context "with valid parameters" do
      it "updates the user" do
        patch "/users/#{target_user.id}", params: { user: { name: "Updated Name" } }
        expect(target_user.reload.name).to eq("Updated Name")
      end

      it "redirects to the users list" do
        patch "/users/#{target_user.id}", params: { user: { name: "Updated Name" } }
        expect(response).to redirect_to(users_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the user" do
        patch "/users/#{target_user.id}", params: { user: { email: "" } }
        expect(target_user.reload.email).not_to be_empty
      end

      it "renders the edit form" do
        patch "/users/#{target_user.id}", params: { user: { email: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /users/:id" do
    let!(:target_user) { create(:user) }

    it "deletes the user" do
      expect {
        delete "/users/#{target_user.id}"
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      delete "/users/#{target_user.id}"
      expect(response).to redirect_to(users_path)
    end
  end

  describe "authentication" do
    it "requires authentication" do
      sign_out
      get "/users"
      expect(response).to redirect_to(login_path)
    end
  end
end
