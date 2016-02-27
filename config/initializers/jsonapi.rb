JSONAPI.configure do |config|
  config.operations_processor = :jsonapi_authorization

  config.exception_class_whitelist = [Pundit::NotAuthorizedError]

  # Workaround for current lack of include support in Ember Data
  # TODO: remove when Ember Data eager-loading support improves
  config.always_include_to_one_linkage_data = true
end
