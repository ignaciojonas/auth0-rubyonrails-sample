# frozen_string_literal: true
class DashboardController < SecuredController
  include Secured
  include ClientHelper
  def show
    @user = ClientHelper.client_user(session[:userinfo]).user_info
  end
end
