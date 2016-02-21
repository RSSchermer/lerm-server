class Statement < ActiveRecord::Base
  belongs_to :rule

  validates :condition, presence: true
  validates :consequence, presence: true
  validates :rule_id, presence: true
end
