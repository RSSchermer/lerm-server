class Api::V1::CurrentUserController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!
end
