class Api::V1::UserResource < Api::V1::BaseResource
  immutable

  attributes :email, :username, :first_name, :last_name

  has_many :memberships

  filter :email
end
