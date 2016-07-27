# require "base64"
# #require "omniauth-oauth2"
#
# module OmniAuth
#   module Strategies
#
#     class OAuth2
#       include OmniAuth::Strategy
#
#       def self.inherited(subclass)
#         OmniAuth::Strategy.included(subclass)
#       end
#
#       args [:client_id, :client_secret]
#
#       option :client_id, nil
#       option :client_secret, nil
#       option :client_options, {}
#       option :authorize_params, {}
#       option :authorize_options, [:scope]
#       option :token_params, {}
#       option :token_options, []
#       option :auth_token_params, {}
#       option :provider_ignores_state, false
#
#       attr_accessor :access_token
#
#       def client
#         ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
#       end
#
#       credentials do
#         hash = {"token" => access_token.token}
#         hash.merge!("refresh_token" => access_token.refresh_token) if access_token.expires? && access_token.refresh_token
#         hash.merge!("expires_at" => access_token.expires_at) if access_token.expires?
#         hash.merge!("expires" => access_token.expires?)
#         hash
#       end
#
#       def request_phase
#         redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
#       end
#
#       def authorize_params
#         options.authorize_params[:state] = SecureRandom.hex(24)
#         params = options.authorize_params.merge(options_for("authorize"))
#         if OmniAuth.config.test_mode
#           @env ||= {}
#           @env["rack.session"] ||= {}
#         end
#         session["omniauth.state"] = params[:state]
#         params
#       end
#
#       def token_params
#         options.token_params.merge(options_for("token"))
#       end
#
#       def callback_phase # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity
#         error = request.params["error_reason"] || request.params["error"]
#         if error
#           fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
#         elsif !options.provider_ignores_state && (request.params["state"].to_s.empty? || request.params["state"] != session.delete("omniauth.state"))
#           fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
#         else
#           self.access_token = build_access_token
#           self.access_token = access_token.refresh! if access_token.expired?
#           super
#         end
#       rescue ::OAuth2::Error, CallbackError => e
#         fail!(:invalid_credentials, e)
#       rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
#         fail!(:timeout, e)
#       rescue ::SocketError => e
#         fail!(:failed_to_connect, e)
#       end
#
#     protected
#
#       def build_access_token
#         verifier = request.params["code"]
#         client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
#       end
#
#       def deep_symbolize(options)
#         hash = {}
#         options.each do |key, value|
#           hash[key.to_sym] = value.is_a?(Hash) ? deep_symbolize(value) : value
#         end
#         hash
#       end
#
#       def options_for(option)
#         hash = {}
#         options.send(:"#{option}_options").select { |key| options[key] }.each do |key|
#           hash[key.to_sym] = options[key]
#         end
#         hash
#       end
#
#       # An error that is indicated in the OAuth 2.0 callback.
#       # This could be a `redirect_uri_mismatch` or other
#       class CallbackError < StandardError
#         attr_accessor :error, :error_reason, :error_uri
#
#         def initialize(error, error_reason = nil, error_uri = nil)
#           self.error = error
#           self.error_reason = error_reason
#           self.error_uri = error_uri
#         end
#
#         def message
#           [error, error_reason, error_uri].compact.join(" | ")
#         end
#       end
#     end
#
#     class Auth0 < OmniAuth::Strategies::OAuth2
#       PASSTHROUGHS = %w[
#         connection
#         redirect_uri
#       ]
#
#       option :name, "auth0"
#       option :namespace, nil
#       option :provider_ignores_state, true
#       option :connection
#
#       option :client_options, {
#         authorize_url: "/authorize",
#         token_url: "/oauth/token",
#         userinfo_url: "/userinfo"
#       }
#
#       args [:client_id, :client_secret, :namespace, :provider_ignores_state, :connection]
#
#       def initialize(app, *args, &block)
#         super
#
#         if options[:namespace]
#           @options.provider_ignores_state = args[3] unless args[3].nil?
#           @options.connection = args[4] unless args[4].nil?
#
#           @options.client_options.site =
#             "https://#{options[:namespace]}"
#           @options.client_options.authorize_url =
#             "https://#{options[:namespace]}/authorize?#{self.class.client_info_querystring}"
#           @options.client_options.token_url =
#             "https://#{options[:namespace]}/oauth/token?#{self.class.client_info_querystring}"
#           @options.client_options.userinfo_url =
#             "https://#{options[:namespace]}/userinfo"
#         elsif !options[:setup]
#           fail(ArgumentError.new("Received wrong number of arguments. #{args.inspect}"))
#         end
#       end
#
#       def authorize_params
#         super.tap do |param|
#           PASSTHROUGHS.each do |p|
#             param[p.to_sym] = request.params[p] if request.params[p]
#           end
#           if @options.connection
#             param[:connection] = @options.connection
#           end
#         end
#       end
#
#       credentials do
#         hash = {'token' => access_token.token}
#         hash.merge!('expires' => true)
#         if access_token.params
#           hash.merge!('id_token' => access_token.params['id_token'])
#           hash.merge!('token_type' => access_token.params['token_type'])
#           hash.merge!('refresh_token' => access_token.refresh_token) if access_token.refresh_token
#         end
#         hash
#       end
#
#       uid { raw_info["user_id"] }
#
#       extra do
#         { :raw_info => raw_info }
#       end
#
#       info do
#         {
#           :name => raw_info["name"],
#           :email => raw_info["email"],
#           :nickname => raw_info["nickname"],
#           :first_name => raw_info["given_name"],
#           :last_name => raw_info["family_name"],
#           :location => raw_info["locale"],
#           :image => raw_info["picture"]
#         }
#       end
#
#       def raw_info
#         @raw_info ||= access_token.get(options.client_options.userinfo_url).parsed
#       end
#
#       def self.client_info_querystring
#         client_info = JSON.dump({name: 'auth0', version: 'OmniAuth::Auth0::VERSION'})
#         "auth0Client=" + Base64.urlsafe_encode64(client_info)
#       end
#     end
#   end
# end
#
# OmniAuth.config.add_camelization "oauth2", "OAuth2"
