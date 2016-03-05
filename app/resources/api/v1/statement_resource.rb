class Api::V1::StatementResource < Api::V1::BaseResource
  attributes :condition, :consequence, :cleaned_condition, :cleaned_consequence, :discarded

  has_one :rule
end
