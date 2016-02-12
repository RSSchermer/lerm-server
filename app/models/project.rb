class Project < ActiveRecord::Base
  has_many :memberships, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
