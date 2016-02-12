class Project < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true
end
