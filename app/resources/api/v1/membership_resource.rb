class Api::V1::MembershipResource < Api::V1::BaseResource
  attributes :user_id, :project_id

  has_one :user
  has_one :project
end
