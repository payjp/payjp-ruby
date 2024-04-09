require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class BalanceTest < Test::Unit::TestCase
    should "balances should be listable" do
      @mock.expects(:get).once.returns(test_response(test_balance_array))
      c = Payjp::Balance.all.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Balance
    end

    should "retrieve should retrieve balance" do
      @mock.expects(:get).once.returns(test_response(test_balance))
      balance = Payjp::Balance.retrieve('ba_test_balance')
      assert_equal 'ba_test_balance', balance.id
    end

    should "balances should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_balance))
        balance = Payjp::Balance.retrieve('ba_test_balance')
        balance.delete
      end
    end
  end
end
