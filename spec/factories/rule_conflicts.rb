FactoryGirl.define do
  factory :rule_conflict do
    rule_1 { create(:rule) }
    rule_2 { create(:rule) }
    description { Faker::Lorem::sentences }
    project { create(:project) }
  end
end
