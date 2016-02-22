FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'some_password'
    sequence(:username) { |n| "#{Faker::Lorem.word}_#{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    factory :super_admin do
      super_admin true
    end
  end
end