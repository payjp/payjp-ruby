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

### Retry on HTTP Status Code 429
* See [Rate Limit Guideline](https://pay.jp/docs/guideline-rate-limit#2-%E3%83%AA%E3%83%88%E3%83%A9%E3%82%A4)
* When you exceeded rate-limit, you can retry request by setting `max_retry`
  like `Payjp.max_retry = 3` .
* The retry interval base value is `retry_initial_delay`
  Adjust the value like `Payjp.retry_initial_delay = 4`
  The smaller is shorter.
* The Maximum retry time is `retry_max_delay`.
  Adjust the value like 'Payjp.retry_max_delay = 32' 
* The retry interval calcurating is based on "Exponential backoff with equal jitter" algorithm.
  See https://aws.amazon.com/jp/blogs/architecture/exponential-backoff-and-jitter/

how to use

```ruby
require 'payjp'
Payjp.api_key = 'sk_test_c62fade9d045b54cd76d7036'
Payjp.max_retry = 3
Payjp.retry_initial_delay = 2
Payjp.retry_max_delay = 32

charge = Payjp::Charge.create(
  :amount => 3500,
  :card => 'token_id',
  :currency => 'jpy',
)
```

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
