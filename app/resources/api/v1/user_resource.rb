class Api::V1::UserResource < Api::V1::BaseResource
  immutable

  attribute :email

  has_many :projects
end
