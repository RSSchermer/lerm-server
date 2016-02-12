module Api
  module V1
    class ProjectsController < BaseResourceController
      def destroy
        head :method_not_allowed
      end
    end
  end
end
