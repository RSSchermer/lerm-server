class Api::V1::BaseResourceController < ActionController::Base
  include JSONAPI::ActsAsResourceController

  rescue_from Pundit::NotAuthorizedError, with: :reject_forbidden_request

  private

  # TODO: this will be resolved in jsonapi-resources 0.7.1, remove this workaround when upgrading
  def handle_exceptions(e)
    if JSONAPI.configuration.exception_class_whitelist.any? { |k| e.class.ancestors.include?(k) }
      raise e
    else
      super
    end
  end

  def reject_forbidden_request
    head :forbidden
  end

  def current_user
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def context
    { user: current_user }
  end
end
