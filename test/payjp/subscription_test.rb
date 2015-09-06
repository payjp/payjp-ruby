require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class SubscriptionTest < Test::Unit::TestCase
    should "subscriptions should be listable" do
      @mock.expects(:get).once.returns(test_response(test_customer))

      customer = Payjp::Customer.retrieve('test_customer')

      assert customer.subscriptions.first.is_a?(Payjp::Subscription)
    end

    should "subscriptions should be refreshable" do
      @mock.expects(:get).twice.returns(test_response(test_customer), test_response(test_subscription(:id => 'refreshed_subscription')))

      customer = Payjp::Customer.retrieve('test_customer')
      subscription = customer.subscriptions.first
      subscription.refresh

      assert_equal 'refreshed_subscription', subscription.id
    end

    should "subscriptions should be deletable" do
      @mock.expects(:get).once.returns(test_response(test_customer))
      customer = Payjp::Customer.retrieve('test_customer')
      subscription = customer.subscriptions.first

      @mock.expects(:delete).once.with("#{Payjp.api_base}/v1/subscriptions/#{subscription.id}?at_period_end=true", nil, nil).returns(test_response(test_subscription))
      subscription.delete :at_period_end => true

      @mock.expects(:delete).once.with("#{Payjp.api_base}/v1/subscriptions/#{subscription.id}", nil, nil).returns(test_response(test_subscription))
      subscription.delete
    end

    should "subscriptions should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_customer))
      @mock.expects(:post).once.returns(test_response(test_subscription({ :status => 'active' })))

      customer = Payjp::Customer.retrieve('test_customer')
      subscription = customer.subscriptions.first
      assert_equal 'trialing', subscription.status

      subscription.status = 'active'
      subscription.save

      assert_equal 'active', subscription.status
    end

    should "create should return a new subscription" do
      @mock.expects(:get).once.returns(test_response(test_customer))
      @mock.expects(:post).once.returns(test_response(test_subscription(:id => 'test_new_subscription')))

      customer = Payjp::Customer.retrieve('test_customer')
      subscription = customer.subscriptions.create(:plan => 'silver')
      assert_equal 'test_new_subscription', subscription.id
    end
  end
end
