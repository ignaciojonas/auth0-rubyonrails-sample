# Customizing Lock
[Full Tutorial](https://auth0.com/docs/quickstart/webapp/rails/09-customizing-lock)

This example shows how to customize the Lock widget, as it is oftentimes required to update it to match the look and feel of your app.

## Running the Sample Application
In order to run the example you need to have ruby installed.

You also need to set the ClientSecret, ClientId, Domain and CallbackURL for your Auth0 app as environment variables with the following names respectively: `AUTH0_CLIENT_SECRET`, `AUTH0_CLIENT_ID`, `AUTH0_DOMAIN` and `AUTH0_CALLBACK_URL`.

For that, if you just create a file named `.env` in the project directory and set the values as follows, the app will just work:

````bash
# .env file
AUTH0_CLIENT_SECRET=myCoolSecret
AUTH0_CLIENT_ID=myCoolClientId
AUTH0_DOMAIN=samples.auth0.com
AUTH0_CALLBACK_URL=http://localhost:3000/auth/auth0/callback
````
Once you've set those 4 environment variables, run `bundle install` and then `rails s`. Now, browse [http://localhost:3000/](http://localhost:3000/).

Shut it down manually with Ctrl-C.

__Note:__ If you are using Windows, uncomment the `tzinfo-data` gem in the gemfile.

## Important Snippets

### 1. Customizing the Lock instance

```ruby
var options = {
   auth: {
		redirectUrl: '<%= Rails.application.secrets.auth0_callback_url %>',
		params: {
			scope: 'openid name email picture'
		}
        },
   theme: {
          logo: "<%= image_url('test-icon.png')%>",
          primaryColor: '#b81b1c'
        },
   languageDictionary: {
          title: 'My Company'
        }
 };
var lock = new Auth0Lock('<%= Rails.application.secrets.auth0_client_id %>', '<%= Rails.application.secrets.auth0_domain %>', options);

function signin() {
	lock.show();
}
```

## Used Libraries
* [Auth0 Lock](https://github.com/auth0/lock)
* [OmniAuth](https://github.com/intridea/omniauth)
* [OmniAuth Auth0 Strategy](https://github.com/auth0/omniauth-auth0)
* [OmniAuth Oauth2](https://github.com/intridea/omniauth-oauth2)
