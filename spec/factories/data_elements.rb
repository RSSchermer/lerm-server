FactoryGirl.define do
  factory :data_element do
    label { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    project { create(:project) }
  end
end
