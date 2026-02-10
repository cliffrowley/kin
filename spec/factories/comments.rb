FactoryBot.define do
  factory :comment do
    body { "This sounds great!" }
    association :user
    association :commentable, factory: :artefact
  end
end
