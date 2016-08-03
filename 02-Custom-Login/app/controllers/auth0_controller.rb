# frozen_string_literal: true
class Auth0Controller < ApplicationController
  # Once the login or login with Google is clicked this method is called.
  def callback
    if params[:user]
      signup if params[:signup]
      session[:token_id] = login
    else
      session[:token_id] = google_login
    end
    redirect_to '/dashboard'
  rescue Auth0::Unauthorized
    redirect_to '/', notice: 'Invalid email or password'
  rescue => ex
    redirect_to '/', notice: ex.message
  end

  # Used to redirect to auth0 authorization url to login with Google.
  def google_authorize
    redirect_to client.authorization_url(
      Rails.application.secrets.auth0_callback_url,
      connection: 'google-oauth2',
      scope: 'openid'
    ).to_s
  end

  private

  # Used to get the user token when the user logins using Google.
  def google_login
    client.obtain_user_tokens(params['code'], Rails.application.secrets.auth0_callback_url, 'google-oauth2', 'openid')['id_token']
  end

  # Used to login with usename and password using the Auth0-Ruby SDK.
  def login
    client.login(
      params[:user],
      params[:password],
      authParams: {
        scope: 'openid name email'
      },
      connection: 'Username-Password-Authentication'
    )
  end

  # Used to signup using the Auth0-Ruby SDK.
  def signup
    client.signup(
      params[:user],
      params[:password]
    )
  end
end
