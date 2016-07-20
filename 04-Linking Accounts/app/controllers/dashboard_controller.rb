# frozen_string_literal: true
class DashboardController < SecuredController
  def show
    @user = session[:userinfo]
  end
end
