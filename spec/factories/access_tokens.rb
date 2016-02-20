FactoryGirl.define do
  factory :access_token, :class => Doorkeeper::AccessToken do
    application nil
    resource_owner_id nil
  end
end
