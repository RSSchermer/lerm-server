module Api
  module V1
    class UsersController < BaseResourceController
      before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]
    end
  end
end