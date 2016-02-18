class Api::V1::MembershipsController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]
end
