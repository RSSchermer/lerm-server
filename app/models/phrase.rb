class Phrase < ActiveRecord::Base
  belongs_to :rule

  validates :text, presence: true, uniqueness: { scope: :rule }
  validates :rule_id, presence: true
end
