# PAY.JP for Ruby

## How to Use

```ruby
require 'payjp'
Payjp.api_key = 'sk_test_c62fade9d045b54cd76d7036'
Payjp.open_timeout = 30 # optionally
Payjp.read_timeout = 90 # optionally

# ex, create charge
charge = Payjp::Charge.create(
  :amount => 3500,
  :card => 'token_id',
  :currency => 'jpy',
)
```

| `Payjp` variables | type | required | description |
| ----------------- | ---- | -------- | ----------- |
| api_key | String | yes | your secret key |
| open_timeout | Integer | no | the second to wait for TCP connection opening (default 30) |
| read_timeout | Integer | no | the second to wait from request to reading response (default 90) |

For detail, See [PAY.JP API Docs](https://pay.jp/docs/api/)

## Installation

```sh
gem install payjp
```

If you want to build the gem from source:

```sh
gem build payjp.gemspec
```

### Requirements

* Ruby 2.0.0 or above.
* rest-client

### Bundler

If you are installing via bundler, you should be sure to use the https
rubygems source in your Gemfile, as any gems fetched over http could potentially be
compromised in transit and alter the code of gems fetched securely over https:

```
source 'https://rubygems.org'

gem 'rails'
gem 'payjp'
```

## Development

Test cases can be run with: `bundle exec rake test`
