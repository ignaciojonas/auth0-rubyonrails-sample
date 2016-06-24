class SettingsController < SecuredController
  def show
  @providers = [
        ['Facebook','facebook'],
        ['Github','github'],
        ['Google','google-oauth2'],
        ['Twitter','twitter']
  ]
  end
end
