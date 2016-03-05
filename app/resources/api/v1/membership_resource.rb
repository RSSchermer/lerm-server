class Api::V1::MembershipResource < Api::V1::BaseResource
  has_one :user
  has_one :project
end
