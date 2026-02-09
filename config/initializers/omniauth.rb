Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    Rails.application.credentials.dig(:google, :client_id),
    Rails.application.credentials.dig(:google, :client_secret)

  provider :developer if Rails.env.development?
end

OmniAuth.config.allowed_request_methods = [ :post ]
