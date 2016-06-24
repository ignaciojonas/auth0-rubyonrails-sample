class SettingsController < SecuredController
  def show
  @user = session[:userinfo]
  @providers = [
        ['Facebook','facebook'],
        ['Github','github'],
        ['Google','google-oauth2'],
        ['Twitter','twitter']
  ]
  end
  def link_provider
    user = session[:userinfo]
    link_user = session[:linkuserinfo]

    v2_creds = { client_id: ENV['AUTH0_CLIENT_ID'],
     token: user[:credentials][:id_token],
     api_version: 2,
     domain: ENV['AUTH0_DOMAIN'] }

    client = Auth0Client.new(v2_creds)

    client.link_user_account(user['uid'], { link_with: link_user[:credentials][:id_token] })

    redirect_to '/settings', notice: "Provider succesfully linked."
  end
  def unlink_provider
  end
end
