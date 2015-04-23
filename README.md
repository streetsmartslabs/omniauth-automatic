# Omniauth Automatic Strategy

[![Build Status](https://travis-ci.org/Automatic/omniauth-automatic.png)](https://travis-ci.org/Automatic/omniauth-automatic)
[![Gem Version](https://badge.fury.io/rb/omniauth-automatic.svg)](http://badge.fury.io/rb/omniauth-automatic)

OAuth2 strategy for [`omniauth`](http://rubygems.org/gems/omniauth) and
[Automatic](https://developer.automatic.com/).

## Installation

Add this line to your application's Gemfile:

```sh
gem 'omniauth-automatic'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install omniauth-automatic
```

## Demo

You can see a demo version of usage of this `gem` at: [http://automatic-omniauth-example.herokuapp.com/](http://automatic-omniauth-example.herokuapp.com/)

## Usage

You first need to sign up for API access and then [register an
application](https://developer.automatic.com/dashboard/).

### Ruby

For use in a _Sinatra_ or _Ruby on Rails_ application:

```ruby
use OmniAuth::Builder do
  provider :automatic, ENV.fetch('AUTOMATIC_CLIENT_ID'), ENV.fetch('AUTOMATIC_CLIENT_SECRET')
end
```

### Scopes

The API lets you specify scopes to provide focused access. By default
you have access to [all valid scopes](https://developer.automatic.com/documentation/#scopes).

```ruby
use OmniAuth::Builder do
  provider :automatic, ENV.fetch('AUTOMATIC_CLIENT_ID'), ENV.fetch('AUTOMATIC_CLIENT_SECRET'), {
    scope: 'scope:trip scope:vehicle:profile'
  }
end
```


## Contributing

1. Fork it ( http://github.com/Automatic/omniauth-automatic/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

This project is licensed under the terms of the Apache 2.0 license.
