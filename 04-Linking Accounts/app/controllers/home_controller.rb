class HomeController < ApplicationController
  def show
    @user = session[:userinfo]
  end
end
