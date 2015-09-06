# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class ApiResourceTest < Test::Unit::TestCase
    should "creating a new APIResource should not fetch over the network" do
      @mock.expects(:get).never
      Payjp::Customer.new("someid")
    end

    should "creating a new APIResource from a hash should not fetch over the network" do
      @mock.expects(:get).never
      Payjp::Customer.construct_from({
        :id => "somecustomer",
        :card => { :id => "somecard", :object => "card" },
        :object => "customer"
      })
    end

    should "setting an attribute should not cause a network request" do
      @mock.expects(:get).never
      @mock.expects(:post).never
      c = Payjp::Customer.new("test_customer")
      c.card = { :id => "somecard", :object => "card" }
    end

    should "accessing id should not issue a fetch" do
      @mock.expects(:get).never
      c = Payjp::Customer.new("test_customer")
      c.id
    end

    should "not specifying api credentials should raise an exception" do
      Payjp.api_key = nil
      assert_raises Payjp::AuthenticationError do
        Payjp::Customer.new("test_customer").refresh
      end
    end

    should "using a nil api key should raise an exception" do
      assert_raises TypeError do
        Payjp::Customer.all({}, nil)
      end
      assert_raises TypeError do
        Payjp::Customer.all({}, { :api_key => nil })
      end
    end

    should "specifying api credentials containing whitespace should raise an exception" do
      Payjp.api_key = "key "
      assert_raises Payjp::AuthenticationError do
        Payjp::Customer.new("test_customer").refresh
      end
    end

    should "specifying invalid api credentials should raise an exception" do
      Payjp.api_key = "invalid"
      response = test_response(test_invalid_api_key_error, 401)
      assert_raises Payjp::AuthenticationError do
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 401))
        Payjp::Customer.retrieve("failing_customer")
      end
    end

    should "AuthenticationErrors should have an http status, http body, and JSON body" do
      Payjp.api_key = "invalid"
      response = test_response(test_invalid_api_key_error, 401)
      begin
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 401))
        Payjp::Customer.retrieve("failing_customer")
      rescue Payjp::AuthenticationError => e
        assert_equal(401, e.http_status)
        assert_equal(true, !!e.http_body)
        assert_equal(true, !!e.json_body[:error][:message])
        assert_equal(test_invalid_api_key_error[:error][:message], e.json_body[:error][:message])
      end
    end

    should "send expand on fetch properly" do
      @mock.expects(:get).once.
        with("#{Payjp.api_base}/v1/charges/ch_test_charge?expand[]=customer", nil, nil).
        returns(test_response(test_charge))

      Payjp::Charge.retrieve({ :id => 'ch_test_charge', :expand => [:customer] })
    end

    should "preserve expand across refreshes" do
      @mock.expects(:get).twice.
        with("#{Payjp.api_base}/v1/charges/ch_test_charge?expand[]=customer", nil, nil).
        returns(test_response(test_charge))

      ch = Payjp::Charge.retrieve({ :id => 'ch_test_charge', :expand => [:customer] })
      ch.refresh
    end

    should "send payjp account as header when set" do
      payjp_account = "acct_0000"
      Payjp.expects(:execute_request).with do |opts|
        opts[:headers][:payjp_account] == payjp_account
      end.returns(test_response(test_charge))

      Payjp::Charge.create({ :card => { :number => '4242424242424242' } },
                           { :payjp_account => payjp_account, :api_key => 'sk_test_local' })
    end

    should "not send payjp account as header when not set" do
      Payjp.expects(:execute_request).with do |opts|
        opts[:headers][:payjp_account].nil?
      end.returns(test_response(test_charge))

      Payjp::Charge.create({ :card => { :number => '4242424242424242' } },
                           'sk_test_local')
    end

    context "when specifying per-object credentials" do
      context "with no global API key set" do
        should "use the per-object credential when creating" do
          api_key = 'sk_test_local'
          Payjp.expects(:execute_request).with do |opts|
            opts[:headers][:authorization] == encode_credentials(api_key)
          end.returns(test_response(test_charge))

          Payjp::Charge.create({ :card => { :number => '4242424242424242' } },
                               api_key)
        end
      end

      context "with a global API key set" do
        setup do
          Payjp.api_key = "global"
        end

        teardown do
          Payjp.api_key = nil
        end

        should "use the per-object credential when creating" do
          api_key = 'local'
          Payjp.expects(:execute_request).with do |opts|
            opts[:headers][:authorization] == encode_credentials(api_key)
          end.returns(test_response(test_charge))

          Payjp::Charge.create({ :card => { :number => '4242424242424242' } },
                               api_key)
        end

        should "use the per-object credential when retrieving and making other calls" do
          api_key = 'local'
          Payjp.expects(:execute_request).with do |opts|
            opts[:url] == "#{Payjp.api_base}/v1/charges/ch_test_charge" &&
              opts[:headers][:authorization] == encode_credentials(api_key)
          end.returns(test_response(test_charge))
          Payjp.expects(:execute_request).with do |opts|
            opts[:url] == "#{Payjp.api_base}/v1/charges/ch_test_charge/refund" &&
              opts[:headers][:authorization] == encode_credentials(api_key)
          end.returns(test_response(test_charge))

          ch = Payjp::Charge.retrieve('ch_test_charge', api_key)
          ch.refund
        end
      end
    end

    context "with valid credentials" do
      should "send along the idempotency-key header" do
        Payjp.expects(:execute_request).with do |opts|
          opts[:headers][:idempotency_key] == 'bar'
        end.returns(test_response(test_charge))

        Payjp::Charge.create({ :card => { :number => '4242424242424242' } }, {
          :idempotency_key => 'bar',
          :api_key => 'local'
        })
      end

      should "urlencode values in GET params" do
        response = test_response(test_charge_array)
        @mock.expects(:get).with("#{Payjp.api_base}/v1/charges?customer=test%20customer", nil, nil).returns(response)
        charges = Payjp::Charge.all(:customer => 'test customer').data
        assert charges.is_a? Array
      end

      should "a 400 should give an InvalidRequestError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 400)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Payjp::Customer.retrieve("foo")
        rescue Payjp::InvalidRequestError => e
          assert_equal(400, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.is_a?(Hash))
        end
      end

      should "a 401 should give an AuthenticationError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 401)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Payjp::Customer.retrieve("foo")
        rescue Payjp::AuthenticationError => e
          assert_equal(401, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.is_a?(Hash))
        end
      end

      should "a 402 should give a CardError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 402)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Payjp::Customer.retrieve("foo")
        rescue Payjp::CardError => e
          assert_equal(402, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.is_a?(Hash))
        end
      end

      should "a 404 should give an InvalidRequestError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 404)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Payjp::Customer.retrieve("foo")
        rescue Payjp::InvalidRequestError => e
          assert_equal(404, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.is_a?(Hash))
        end
      end

      should "setting a nil value for a param should exclude that param from the request" do
        @mock.expects(:get).with do |url, _api_key, _params|
          uri = URI(url)
          query = CGI.parse(uri.query)
          (url =~ %r{^#{Payjp.api_base}/v1/charges?} &&
           query.keys.sort == ['offset', 'sad'])
        end.returns(test_response({ :count => 1, :data => [test_charge] }))
        Payjp::Charge.all(:count => nil, :offset => 5, :sad => false)

        @mock.expects(:post).with do |url, api_key, params|
          url == "#{Payjp.api_base}/v1/charges" &&
            api_key.nil? &&
            CGI.parse(params) == { 'amount' => ['50'], 'currency' => ['jpy'] }
        end.returns(test_response({ :count => 1, :data => [test_charge] }))
        Payjp::Charge.create(:amount => 50, :currency => 'jpy', :card => { :number => nil })
      end

      should "requesting with a unicode ID should result in a request" do
        response = test_response(test_missing_id_error, 404)
        @mock.expects(:get).once.with("#{Payjp.api_base}/v1/customers/%E2%98%83", nil, nil).raises(RestClient::ExceptionWithResponse.new(response, 404))
        c = Payjp::Customer.new("☃")
        assert_raises(Payjp::InvalidRequestError) { c.refresh }
      end

      should "requesting with no ID should result in an InvalidRequestError with no request" do
        c = Payjp::Customer.new
        assert_raises(Payjp::InvalidRequestError) { c.refresh }
      end

      should "making a GET request with parameters should have a query string and no body" do
        params = { :limit => 1 }
        @mock.expects(:get).once.with("#{Payjp.api_base}/v1/charges?limit=1", nil, nil).returns(test_response([test_charge]))
        Payjp::Charge.all(params)
      end

      should "making a POST request with parameters should have a body and no query string" do
        params = { :amount => 100, :currency => 'jpy', :card => 'sc_token' }
        @mock.expects(:post).once.with do |_url, get, post|
          get.nil? && CGI.parse(post) == { 'amount' => ['100'], 'currency' => ['jpy'], 'card' => ['sc_token'] }
        end.returns(test_response(test_charge))
        Payjp::Charge.create(params)
      end

      should "loading an object should issue a GET request" do
        @mock.expects(:get).once.returns(test_response(test_customer))
        c = Payjp::Customer.new("test_customer")
        c.refresh
      end

      should "using array accessors should be the same as the method interface" do
        @mock.expects(:get).once.returns(test_response(test_customer))
        c = Payjp::Customer.new("test_customer")
        c.refresh
        assert_equal c.created, c[:created]
        assert_equal c.created, c['created']
        c['created'] = 12345
        assert_equal c.created, 12345
      end

      should "updating an object should issue a POST request with only the changed properties" do
        @mock.expects(:post).with do |url, api_key, params|
          url == "#{Payjp.api_base}/v1/customers/c_test_customer" && api_key.nil? && CGI.parse(params) == { 'description' => ['another_mn'] }
        end.once.returns(test_response(test_customer))
        c = Payjp::Customer.construct_from(test_customer)
        c.description = "another_mn"
        c.save
      end

      should "updating should merge in returned properties" do
        @mock.expects(:post).once.returns(test_response(test_customer))
        c = Payjp::Customer.new("c_test_customer")
        c.description = "another_mn"
        c.save
        assert_equal false, c.livemode
      end

      should "deleting should send no props and result in an object that has no props other deleted" do
        @mock.expects(:get).never
        @mock.expects(:post).never
        @mock.expects(:delete).with("#{Payjp.api_base}/v1/customers/c_test_customer", nil, nil).once.returns(test_response({ "id" => "test_customer", "deleted" => true }))
        c = Payjp::Customer.construct_from(test_customer)
        c.delete
        assert_equal true, c.deleted

        assert_raises NoMethodError do
          c.livemode
        end
      end

      should "loading an object with properties that have specific types should instantiate those classes" do
        @mock.expects(:get).once.returns(test_response(test_charge))
        c = Payjp::Charge.retrieve("test_charge")
        assert c.card.is_a?(Payjp::PayjpObject) && c.card.object == 'card'
      end

      should "loading all of an APIResource should return an array of recursively instantiated objects" do
        @mock.expects(:get).once.returns(test_response(test_charge_array))
        c = Payjp::Charge.all.data
        assert c.is_a? Array
        assert c[0].is_a? Payjp::Charge
        assert c[0].card.is_a?(Payjp::PayjpObject) && c[0].card.object == 'card'
      end

      should "passing in a payjp_account header should pass it through on call" do
        Payjp.expects(:execute_request).with do |opts|
          opts[:method] == :get &&
            opts[:url] == "#{Payjp.api_base}/v1/customers/c_test_customer" &&
            opts[:headers][:payjp_account] == 'acct_abc'
        end.once.returns(test_response(test_customer))
        Payjp::Customer.retrieve("c_test_customer", { :payjp_account => 'acct_abc' })
      end

      should "passing in a payjp_account header should pass it through on save" do
        Payjp.expects(:execute_request).with do |opts|
          opts[:method] == :get &&
            opts[:url] == "#{Payjp.api_base}/v1/customers/c_test_customer" &&
            opts[:headers][:payjp_account] == 'acct_abc'
        end.once.returns(test_response(test_customer))
        c = Payjp::Customer.retrieve("c_test_customer", { :payjp_account => 'acct_abc' })

        Payjp.expects(:execute_request).with do |opts|
          opts[:method] == :post &&
            opts[:url] == "#{Payjp.api_base}/v1/customers/c_test_customer" &&
            opts[:headers][:payjp_account] == 'acct_abc' &&
            opts[:payload] == 'description=FOO'
        end.once.returns(test_response(test_customer))
        c.description = 'FOO'
        c.save
      end

      context "error checking" do
        should "404s should raise an InvalidRequestError" do
          response = test_response(test_missing_id_error, 404)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))

          rescued = false
          begin
            Payjp::Customer.new("test_customer").refresh
            assert false # shouldn't get here either
          rescue Payjp::InvalidRequestError => e # we don't use assert_raises because we want to examine e
            rescued = true
            assert e.is_a? Payjp::InvalidRequestError
            assert_equal "id", e.param
            assert_equal "Missing id", e.message
          end

          assert_equal true, rescued
        end

        should "5XXs should raise an APIError" do
          response = test_response(test_api_error, 500)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 500))

          rescued = false
          begin
            Payjp::Customer.new("test_customer").refresh
            assert false # shouldn't get here either
          rescue Payjp::APIError => e # we don't use assert_raises because we want to examine e
            rescued = true
            assert e.is_a? Payjp::APIError
          end

          assert_equal true, rescued
        end

        should "402s should raise a CardError" do
          response = test_response(test_invalid_exp_year_error, 402)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 402))

          rescued = false
          begin
            Payjp::Customer.new("test_customer").refresh
            assert false # shouldn't get here either
          rescue Payjp::CardError => e # we don't use assert_raises because we want to examine e
            rescued = true
            assert e.is_a? Payjp::CardError
            assert_equal "invalid_expiry_year", e.code
            assert_equal "exp_year", e.param
            assert_equal "Your card's expiration year is invalid", e.message
          end

          assert_equal true, rescued
        end
      end

      should 'save nothing if nothing changes' do
        ch = Payjp::Charge.construct_from({
          :id => 'charge_id',
          :customer => {
            :object => 'customer',
            :id => 'customer_id'
          }
        })

        @mock.expects(:post).once.with("#{Payjp.api_base}/v1/charges/charge_id", nil, '').returns(test_response({ "id" => "charge_id" }))
        ch.save
      end

      should 'not save nested API resources' do
        ch = Payjp::Charge.construct_from({
          :id => 'charge_id',
          :customer => {
            :object => 'customer',
            :id => 'customer_id'
          }
        })

        @mock.expects(:post).once.with("#{Payjp.api_base}/v1/charges/charge_id", nil, '').returns(test_response({ "id" => "charge_id" }))

        ch.customer.description = 'Bob'
        ch.save
      end
    end
  end
end
