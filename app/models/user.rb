class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships

  def project_member?(project_id)
    Membership.where(user_id: id, project_id: project_id).exists?
  end
end
