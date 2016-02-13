module Api
  module V1
    class ProjectsController < BaseResourceController
      before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]

      def destroy
        head :method_not_allowed
      end
    end
  end
end
