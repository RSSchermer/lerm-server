FactoryGirl.define do
  factory :rule_conflict do
    rule_one { create(:rule) }
    rule_two { create(:rule) }
    description { Faker::Lorem::sentences }
    project { create(:project) }
  end
end
