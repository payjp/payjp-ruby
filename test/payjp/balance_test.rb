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

    should "statement_urls should be callable" do
      @mock.expects(:get).never
      @mock.expects(:post).once.returns(test_response({ :object => "statement_url", :url => 'https://pay.jp/_/statements/8f9ec721bc734dbcxxxxxxxxxxxxxxxx', :expires => 1476676539 }))
      c = Payjp::Statement.new('st_test')
      response = c.statement_urls()
      assert_equal response[:url], 'https://pay.jp/_/statements/8f9ec721bc734dbcxxxxxxxxxxxxxxxx'
    end
  end
end
