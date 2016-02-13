class Rule < ActiveRecord::Base
  default_scope { order(:label) }

  belongs_to :project

  validates :label, presence: true, uniqueness: { scope: :project }
  validates :original_text, presence: true
  validates :project_id, presence: true
end
