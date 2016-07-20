# frozen_string_literal: true
class SettingsController < SecuredController
  def show
    @user = session[:userinfo]
    @providers = user_providers.keys.collect { |x| [x, x] }
    # [
    #       ['Facebook','facebook'],
    #       ['Github','github'],
    #       ['Google','google-oauth2'],
    #       ['Twitter','twitter']
    # ]
  end

  def link_provider
    user = session[:userinfo]
    link_user = session[:linkuserinfo]

    v2_creds = { client_id: ENV['AUTH0_CLIENT_ID'],
                 token: user[:credentials][:id_token],
                 api_version: 2,
                 domain: ENV['AUTH0_DOMAIN'] }

    client = Auth0Client.new(v2_creds)

    client.link_user_account(user['uid'], link_with: link_user[:credentials][:id_token])

    redirect_to '/settings', notice: 'Provider succesfully linked.'
  end

  def unlink_provider
    user = session[:userinfo]

    v2_creds = { client_id: ENV['AUTH0_CLIENT_ID'],
                 token: user[:credentials][:id_token],
                 api_version: 2,
                 domain: ENV['AUTH0_DOMAIN'] }

    client = Auth0Client.new(v2_creds)
    result = client.unlink_users_account(user['uid'], params['unlink_provider'], user_providers[params['unlink_provider']])
    redirect_to '/settings', notice: 'Provider succesfully unlinked.'
  end

  private

  def user_providers
    # TODO: why is it not working with @user?
    user = session[:userinfo]
    Hash[user['extra']['raw_info']['identities'].collect { |identity| [identity['provider'], identity['user_id']] }]
  end
end
