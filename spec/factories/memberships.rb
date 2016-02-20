FactoryGirl.define do
  factory :membership do
    user { FactoryGirl.create(:user) }
    project { FactoryGirl.create(:project) }
  end
end
