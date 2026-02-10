FactoryBot.define do
  factory :artefact do
    sequence(:title) { |n| "Artefact #{n}" }
    notes { nil }
    association :song
  end
end
