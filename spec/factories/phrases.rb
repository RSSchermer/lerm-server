FactoryGirl.define do
  factory :phrase do
    original_text { Faker::Lorem.words }
    cleaned_text { Faker::Lorem.words }
    discarded false
    crisp false
    data_element_expression { Faker::Lorem.words }
    rule { create(:rule) }
  end
end
