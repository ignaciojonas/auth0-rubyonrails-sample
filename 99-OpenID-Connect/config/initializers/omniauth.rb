module OmniAuth
  module Strategies
    autoload :Auth02, Rails.root.join('lib', 'strategies', 'auth02')
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
      :auth02,
      ENV['AUTH0_CLIENT_ID'],
      ENV['AUTH0_CLIENT_SECRET'],
      ENV['AUTH0_DOMAIN'],
      callback_path: '/auth/auth0/callback'
    )
end

# module OmniAuth
#   module Strategies
#     autoload :Auth0, Rails.root.join('lib', 'strategies', 'auth0')
#   end
# end
#
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider(
#       :auth0,
#       ENV['AUTH0_CLIENT_ID'],
#       ENV['AUTH0_CLIENT_SECRET'],
#       ENV['AUTH0_DOMAIN'],
#       callback_path: '/auth/auth0/callback'
#     )
# end
