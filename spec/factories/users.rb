FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'some_password'
    username { Faker::Lorem.word }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    factory :super_admin do
      super_admin true
    end
  end
end