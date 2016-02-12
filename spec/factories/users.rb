require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'some_password' }

    factory :super_admin do
      super_admin true
    end
  end
end