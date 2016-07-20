# frozen_string_literal: true
class Auth0Controller < ApplicationController
  def callback
    # example request.env['omniauth.auth'] in https://github.com/auth0/omniauth-auth0#auth-hash
    # id_token = session[:userinfo]['credentials']['id_token']
    # store the user profile in session and redirect to root
    unless session[:userinfo].present?
      session[:userinfo] = request.env['omniauth.auth']
      redirect_to '/dashboard'
      return
    end
    session[:linkuserinfo] = request.env['omniauth.auth']
    redirect_to '/settings/link_provider'
  end

  def failure
    @error_msg = request.params['message']
  end
end
