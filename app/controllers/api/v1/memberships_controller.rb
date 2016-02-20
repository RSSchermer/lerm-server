class Api::V1::MembershipsController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]
  before_action :authorize_create, only: :create

  def index
    head :unauthorized
  end

  private

  def authorize_create
    project = Project.find(params[:data][:attributes]['project-id'])
    raise Pundit::NotAuthorizedError unless ProjectPolicy.new(context[:user], project).update?
  end
end
