FactoryGirl.define do
  factory :rule_relationship do
    rule_1 { create(:rule) }
    rule_2 { create(:rule) }
    description { Faker::Lorem::sentences }
  end
end
