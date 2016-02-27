class Api::V1::PhrasesController < Api::V1::BaseResourceController
  before_action :doorkeeper_authorize!, except: [:index, :show, :get_related_resources, :show_relationship]
  before_action :authorize_create, only: :create

  def index
    head :unauthorized
  end

  private

  def authorize_create
    rule = Rule.find(params[:data][:attributes]['rule-id'])
    raise Pundit::NotAuthorizedError unless RulePolicy.new(current_user, rule).update?
  end
end
