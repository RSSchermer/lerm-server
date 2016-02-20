JSONAPI.configure do |config|
  config.operations_processor = :jsonapi_authorization

  config.exception_class_whitelist = [Pundit::NotAuthorizedError]
end
