class Api::V1::ProjectsController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]

  def destroy
    head :method_not_allowed
  end
end
