FactoryGirl.define do
  factory :data_element do
    sequence(:label) { |n| "Data Element #{n}" }
    description { Faker::Lorem.sentence }
    project { create(:project) }
  end
end
