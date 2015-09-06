require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class AccountTest < Test::Unit::TestCase
    should "be retrievable" do
      resp = { :email => "test+bindings@pay.jp", :accounts_enabled => ['merchant', 'customer'], :merchant => { :bank_enabled => false } }
      @mock.expects(:get).
        once.
        with("#{Payjp.api_base}/v1/accounts", nil, nil).
        returns(test_response(resp))
      a = Payjp::Account.retrieve
      assert_equal "test+bindings@pay.jp", a.email
      assert_equal ['merchant', 'customer'], a.accounts_enabled
      assert !a.merchant.bank_enabled
    end
  end
end
