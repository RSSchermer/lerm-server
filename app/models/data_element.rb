class DataElement < ActiveRecord::Base
  default_scope { order(:label) }

  belongs_to :project
  has_and_belongs_to_many :phrases
  has_many :rules, through: :phrases

  validates :label, presence: true, uniqueness: { scope: :project }
  validates :description, presence: true
  validates :project_id, presence: true
end
