module Payjp
  module TestData
    def test_response(body, code = 200)
      # When an exception is raised, restclient clobbers method_missing.  Hence we
      # can't just use the stubs interface.
      body = JSON.generate(body) unless body.is_a? String
      m = mock
      m.instance_variable_set('@payjp_values', { :body => body, :code => code })
      def m.body
        @payjp_values[:body]
      end
      def m.code
        @payjp_values[:code]
      end
      m
    end

    def test_customer(params = {})
      id = params[:id] || 'c_test_customer'
      {
        :cards => test_customer_card_array(id),
        :created => 1304114758,
        :default_card => "cc_test_card",
        :description => nil,
        :email => nil,
        :id => id,
        :livemode => false,
        :object => "customer",
        :subscriptions => test_subscription_array(id),
        :metadata => {}
      }.merge(params)
    end

    def test_customer_array
      {
        :count => 3,
        :data => [test_customer, test_customer, test_customer],
        :object => 'list',
        :url => '/v1/customers'
      }
    end

    def test_charge(params = {})
      id = params[:id] || 'ch_test_charge'
      {
        :amount => 3500,
        :amount_refunded => 0,
        :captured => true,
        :card => {
          :address_city => nil,
          :address_line1 => nil,
          :address_line2 => nil,
          :address_state => nil,
          :address_zip => nil,
          :address_zip_check => 'unchecked',
          :brand => "Visa",
          :country => nil,
          :created => 1433127983,
          :cvc_check => "unchecked",
          :exp_month => 2,
          :exp_year => 2020,
          :fingerprint => "e1d8225886e3a7211127df751c86787f",
          :id => "cc_test_card",
          :last4 => "4242",
          :name => nil,
          :object => "card"
        },
        :created => 1433127983,
        :currency => "jpy",
        :customer => nil,
        :description => nil,
        :expired_at => nil,
        :failure_code => nil,
        :failure_message => nil,
        :fee => 0,
        :id => id,
        :livemode => false,
        :object => "charge",
        :paid => true,
        :refund_reason => nil,
        :refunded => false,
        :subscription => nil,
        :metadata => {}
      }.merge(params)
    end

    def test_charge_array
      {
        :count => 3,
        :data => [test_charge, test_charge, test_charge],
        :object => 'list',
        :url => '/v1/charges'
      }
    end

    def test_customer_card_array(customer_id)
      {
        :count => 3,
        :data => [test_card, test_card, test_card],
        :object => 'list',
        :url => '/v1/customers/' + customer_id + '/cards'
      }
    end

    def test_card(params = {})
      {
        :address_city => nil,
        :address_line1 => nil,
        :address_line2 => nil,
        :address_state => nil,
        :address_zip => nil,
        :address_zip_check => 'unchecked',
        :brand => "Visa",
        :country => nil,
        :created => 1433127983,
        :customer => 'test_customer',
        :cvc_check => "unchecked",
        :exp_month => 2,
        :exp_year => 2020,
        :fingerprint => "e1d8225886e3a7211127df751c86787f",
        :id => "cc_test_card",
        :last4 => "4242",
        :livemode => false,
        :name => nil,
        :object => "card"
      }.merge(params)
    end

    def test_event_array
      {
        :count => 3,
        :data => [test_event, test_event, test_event],
        :object => 'list',
        :url => '/v1/events'
      }
    end

    def test_event(params = {})
      {
        :created => 1432973142,
        :data => {},
        :id => 'evnt_test_event',
        :livemode => false,
        :object => 'event',
        :pending_webhooks => 0,
        :type => 'subscription.resumed'
      }.merge(params)
    end

    def test_plan_array
      {
        :count => 3,
        :data => [test_plan, test_plan, test_plan],
        :object => 'list',
        :url => '/v1/plans'
      }
    end

    def test_plan(params = {})
      {
        :amount => 500,
        :created => 1433127983,
        :currency => 'jpy',
        :id => 'pln_test_plan',
        :interval => 'month',
        :livemode => false,
        :object => 'plan',
        :trial_days => 30
      }.merge(params)
    end

    # FIXME: nested overrides would be better than hardcoding plan_id
    def test_subscription(params = {})
      plan = params.delete(:plan) || 'gold'
      {
        :current_period_end => 1308681468,
        :status => "trialing",
        :plan => {
          :interval => "month",
          :amount => 7500,
          :trial_period_days => 30,
          :object => "plan",
          :identifier => plan
        },
        :current_period_start => 1308595038,
        :start => 1308595038,
        :object => "subscription",
        :trial_start => 1308595038,
        :trial_end => 1308681468,
        :customer => "c_test_customer",
        :id => 's_test_subscription'
      }.merge(params)
    end

    def test_subscription_array(customer_id)
      {
        :data => [test_subscription, test_subscription, test_subscription],
        :object => 'list',
        :url => '/v1/customers/' + customer_id + '/subscriptions'
      }
    end

    def test_token(params = {})
      card = params[:card] || {}
      {
        :card => test_card(card),
        :created => 1433127983,
        :id => 'tok_test_token',
        :livemode => false,
        :object => 'token',
        :used => false
      }.merge(params)
    end

    def test_transfer(params = {})
      {
        :amount => 1000,
        :charges => {
          :count => 1,
          :data => [test_charge],
          :object => 'list',
          :url => '/v1/transfers/tr_test_transfer/charges'
        },
        :created => 1432965397,
        :currency => "jpy",
        :date => 1432965401,
        :description => "test",
        :id => "tr_test_transfer",
        :livemode => false,
        :object => "transfer",
        :status => 'paid',
        :summary => {
          :charge_count => 1,
          :charge_fee => 0,
          :charge_gross => 1000,
          :net => 1000,
          :refund_amount => 0,
          :refund_count => 0
        },
        :metadata => {}
      }.merge(params)
    end

    def test_transfer_array
      {
        :count => 3,
        :data => [test_transfer, test_transfer, test_transfer],
        :object => 'list',
        :url => '/v1/transfers'
      }
    end

    def test_invalid_api_key_error
      {
        :error => {
          :type => "invalid_request_error",
          :message => "Invalid API Key provided: invalid"
        }
      }
    end

    def test_invalid_exp_year_error
      {
        :error => {
          :code => "invalid_expiry_year",
          :param => "exp_year",
          :type => "card_error",
          :message => "Your card's expiration year is invalid"
        }
      }
    end

    def test_missing_id_error
      {
        :error => {
          :param => "id",
          :type => "invalid_request_error",
          :message => "Missing id"
        }
      }
    end

    def test_api_error
      {
        :error => {
          :type => "api_error"
        }
      }
    end
  end
end
