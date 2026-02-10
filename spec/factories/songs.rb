FactoryBot.define do
  factory :song do
    sequence(:title) { |n| "Song #{n}" }
    notes { nil }
    association :creator, factory: :user
  end
end
