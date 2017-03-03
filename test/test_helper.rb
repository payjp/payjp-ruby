require 'payjp'
require 'test/unit'
require 'mocha/setup'
require 'stringio'
require File.expand_path('../test_data', __FILE__)

# monkeypatch request methods
module Payjp
  @mock_rest_client = nil

  class << self
    attr_writer :mock_rest_client
    remove_method :execute_request
  end

  def self.execute_request(opts)
    get_params = (opts[:headers] || {})[:params]
    post_params = opts[:payload]
    case opts[:method]
    when :get then @mock_rest_client.get opts[:url], get_params, post_params
    when :post then @mock_rest_client.post opts[:url], get_params, post_params
    when :delete then @mock_rest_client.delete opts[:url], get_params, post_params
    end
  end
end

class Test::Unit::TestCase
  include Payjp::TestData
  include Mocha

  class << self
    alias_method :context, :sub_test_case
    alias_method :should, :test
  end

  def encode_credentials(user_name)
    "Basic #{Base64.strict_encode64("#{user_name}:")}"
  end

  setup do
    @mock = mock
    Payjp.mock_rest_client = @mock
    Payjp.api_key = "foo"
  end

  teardown do
    Payjp.mock_rest_client = nil
    Payjp.api_key = nil
  end
end
