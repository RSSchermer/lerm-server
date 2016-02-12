module Api
  module V1
    class BaseResourceController < ActionController::Base
      include JSONAPI::ActsAsResourceController

      private

      def context
        { user: current_user }
      end
    end
  end
end
