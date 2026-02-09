FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "test@example.com" }
    provider { "google_oauth2" }
    uid { "123456789" }
  end
end
