class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: {
      with: /\A[a-z0-9\-_]+\Z/i,
      message: 'Must consist of only letters, numbers, dashes and underscores.'
  }

  def project_member?(project_id)
    Membership.where(user_id: id, project_id: project_id).exists?
  end
end
