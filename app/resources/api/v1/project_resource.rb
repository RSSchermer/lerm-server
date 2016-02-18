class Api::V1::ProjectResource < Api::V1::BaseResource
  attribute :name

  has_many :memberships
end
