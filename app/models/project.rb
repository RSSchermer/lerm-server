class Project < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :rules, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
