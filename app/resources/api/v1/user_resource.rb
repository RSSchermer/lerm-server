module Api
  module V1
    class UserResource < BaseResource
      immutable

      attribute :email

      has_many :projects
    end
  end
end
