class Auth0Controller < ApplicationController
  def callback
    # In the request.env['omniauth.auth'], OmniAuth is getting the user profile information.
    # We are storing the user profile info in the session
    # In case you need the id_token, you can get it from session[:userinfo]['credentials']['id_token']
    session[:userinfo] = request.env['omniauth.auth']

    redirect_to '/dashboard'
  end

    # if user authentication fails on the provider side, OmniAuth will catch the response
    # and then redirect the request to the path /auth/failure, passing a corresponding
    # error message in a parameter named message.
  def failure
    @error_msg = request.params['message']
  end
end
