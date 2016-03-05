class Api::V1::RuleConflictsController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]

  def index
    head :forbidden
  end
end
