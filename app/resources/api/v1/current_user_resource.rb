class Api::V1::CurrentUserResource < Api::V1::UserResource
  immutable

  model_name 'User'

  def self.find_by_key(key, options = {})
    context = options[:context]
    user = context[:user]
    fail JSONAPI::Exceptions::RecordNotFound.new(key) if user.nil?
    self.resource_for_model(user).new(user, context)
  end

  def self._type
    'users'
  end
end
