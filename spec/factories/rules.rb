FactoryGirl.define do
  factory :rule do
    sequence(:label) { |n| "Rule #{n}" }
    source { Faker::Lorem.word }
    original_text { Faker::Lorem.sentence }
    proactive_form { Faker::Lorem.sentence }
    project { create(:project) }
  end
end
