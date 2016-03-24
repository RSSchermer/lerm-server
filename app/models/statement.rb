class Statement < ActiveRecord::Base
  belongs_to :rule

  validates :original_condition, presence: true
  validates :original_consequence, presence: true
  validates :rule_id, presence: true
end
