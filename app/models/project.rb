class Project < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :rules, dependent: :destroy
  has_many :data_elements, dependent: :destroy
  has_many :rule_conflicts, dependent: :destroy
  has_many :rule_relationships, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
