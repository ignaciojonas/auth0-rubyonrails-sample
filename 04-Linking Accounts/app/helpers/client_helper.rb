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
              token: ENV['AUTH0_MASTER_JWT'],
              api_version: 2,
              domain: ENV['AUTH0_DOMAIN'] }

    Auth0Client.new(creds)
  end
end
