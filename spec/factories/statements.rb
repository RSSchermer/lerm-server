FactoryGirl.define do
  factory :statement do
    condition { Faker::Lorem.sentence }
    consequence { Faker::Lorem.sentence }
    cleaned_condition { Faker::Lorem.sentence }
    cleaned_consequence { Faker::Lorem.sentence }
    discarded false
    rule { create(:rule) }
  end
end
