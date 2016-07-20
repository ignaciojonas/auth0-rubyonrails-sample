class SettingsController < SecuredController
attr_accessor :user, :client
  def show
    @user = session[:userinfo]
    @providers = user_providers.keys.collect { |x| [x, x] }
    creds = { client_id: ENV['AUTH0_CLIENT_ID'],
                 token: user[:credentials][:id_token],
                 api_version: 2,
                 domain: ENV['AUTH0_DOMAIN'] }

    @client = Auth0Client.new(creds)
  end

  def link_provider
    client.link_user_account(user['uid'], link_with: link_user[:credentials][:id_token])
    redirect_to '/settings', notice: 'Provider succesfully linked.'
  end

  def unlink_provider
    result = client.unlink_users_account(user['uid'], params['unlink_provider'], user_providers[params['unlink_provider']])
    redirect_to '/settings', notice: 'Provider succesfully unlinked.'
  end

  private

  def user_providers
    Hash[user['extra']['raw_info']['identities'].collect { |identity| [identity['provider'], identity['user_id']] }]
  end
end
