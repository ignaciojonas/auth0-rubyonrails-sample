# frozen_string_literal: true
module ClientHelper
  def self.client_user(user)
    creds = { client_id: ENV['AUTH0_CLIENT_ID'],
              token: user[:credentials][:token],
              api_version: 2,
              domain: ENV['AUTH0_DOMAIN'] }

    Auth0Client.new(creds)
  end

  def self.client(user)
    creds = { client_id: ENV['AUTH0_CLIENT_ID'],
              token: user[:credentials][:id_token],
              api_version: 2,
              domain: ENV['AUTH0_DOMAIN'] }

    Auth0Client.new(creds)
  end

  def self.client_admin
    creds = { client_id: ENV['AUTH0_CLIENT_ID'],
              token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJLbFNwSmZiVEF0ZXRRUERsS1JrbGtWYUIwVkpDd0pJWSIsInNjb3BlcyI6eyJjb25uZWN0aW9ucyI6eyJhY3Rpb25zIjpbInJlYWQiXX19LCJpYXQiOjE0NjkxODU5MDAsImp0aSI6IjEzYjk5YzIyNzM5MTM0YTRhZjA2YTAzOGM0ODhiOTk2In0.A_x7o9jH4Z6u24rdifac3w6TKRS8jS23JNift5kGd3U',
              api_version: 2,
              domain: ENV['AUTH0_DOMAIN'] }

    Auth0Client.new(creds)
  end
end
