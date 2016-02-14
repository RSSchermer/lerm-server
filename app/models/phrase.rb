class Phrase < ActiveRecord::Base
  belongs_to :rule
  has_and_belongs_to_many :data_elements

  validates :text, presence: true, uniqueness: { scope: :rule }
  validates :rule_id, presence: true
end
