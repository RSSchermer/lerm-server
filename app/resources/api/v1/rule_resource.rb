class Api::V1::RuleResource < Api::V1::BaseResource
  attributes :label, :source, :original_text, :proactive_form, :project_id

  has_one :project
  has_many :phrases
  has_many :statements
end
