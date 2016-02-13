module Api
  module V1
    class BaseResourceController < ActionController::Base
      include JSONAPI::ActsAsResourceController

      private

      def current_user
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def context
        { user: current_user }
      end
    end
  end
end
