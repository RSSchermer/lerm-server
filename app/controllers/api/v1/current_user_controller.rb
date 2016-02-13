module Api
  module V1
    class CurrentUserController < BaseResourceController
      before_action :doorkeeper_authorize!
    end
  end
end
