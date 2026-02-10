FactoryBot.define do
  factory :artefact do
    sequence(:title) { |n| "Artefact #{n}" }
    artefact_type { :mix }
    notes { nil }
    association :song
  end
end
