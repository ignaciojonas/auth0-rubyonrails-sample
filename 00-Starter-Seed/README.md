# Auth0 + Ruby on Rails WebApp Seed
This is the seed project to create a regular web app with Ruby on Rails. If you want to build a Ruby On Rails API that will be used with a SPA or a Mobile device, please check this [other seed project](https://github.com/auth0/ruby-auth0/tree/master/examples/ruby-on-rails-api)

You can learn more about this seed project in the [Auth0 Rails quickstart](https://auth0.com/docs/quickstart/webapp/rails).

# Running the Seed Application
In order to run the example you need to have ruby installed.

You also need to set the ClientSecret, ClientId, Domain and CallbackURL for your Auth0 app as environment variables with the following names respectively: `AUTH0_CLIENT_SECRET`, `AUTH0_CLIENT_ID`, `AUTH0_DOMAIN` and `AUTH0_CALLBACK_URL`.

Set the environment variables in `.env` to match those your Auth0 Client.

````bash
# .env file
AUTH0_CLIENT_ID=myCoolClientId
AUTH0_CLIENT_SECRET=myCoolSecret
AUTH0_DOMAIN=samples.auth0.com
AUTH0_CALLBACK_URL=http://localhost:3000/auth/oauth2/callback
````
__Note:__ Remember to use `https` in the callback URL of your Production Environment.
Once you've set those 4 environment variables, run `bundle install` and then `rails s`. Now, browse [http://localhost:3000/](http://localhost:3000/).

__Note:__ If you are using Windows, uncomment the `tzinfo-data` gem in the gemfile.

## Used Libraries
* [Auth0 Lock](https://github.com/auth0/lock)
* [OmniAuth](https://github.com/intridea/omniauth)
* [OmniAuth Auth0 Strategy](https://github.com/auth0/omniauth-auth0)
* [OmniAuth Oauth2](https://github.com/intridea/omniauth-oauth2)
