class Api::V1::BaseResourceController < ActionController::Base
  include JSONAPI::ActsAsResourceController

  private

  def current_user
    User.find(doorkeeper_token.user_id) if doorkeeper_token
  end

  def context
    { user: current_user }
  end
end
