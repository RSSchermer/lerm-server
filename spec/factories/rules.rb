require 'faker'

FactoryGirl.define do
  factory :rule do
    label Faker::Lorem.word
    source Faker::Lorem.word
    original_text Faker::Lorem.sentence
    proactive_form Faker::Lorem.sentence
    project { create(:project) }
  end
end
