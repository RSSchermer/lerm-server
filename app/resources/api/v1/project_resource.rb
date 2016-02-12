module Api
  module V1
    class ProjectResource < BaseResource
      attribute :name

      has_many :members
    end
  end
end
