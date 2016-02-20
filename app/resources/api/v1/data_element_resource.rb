class Api::V1::DataElementResource < Api::V1::BaseResource
  attributes :label, :description, :project_id

  has_one :project
  has_many :phrases
  has_many :rules
end
