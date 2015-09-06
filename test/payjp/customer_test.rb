require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class CustomerTest < Test::Unit::TestCase
    should "customers should be listable" do
      @mock.expects(:get).once.returns(test_response(test_customer_array))
      c = Payjp::Customer.all.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Customer
    end

    should "customers should be deletable" do
      @mock.expects(:delete).once.returns(test_response(test_customer({ :deleted => true })))
      c = Payjp::Customer.new("test_customer")
      c.delete
      assert c.deleted
    end

    should "customers should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_customer({ :mnemonic => "foo" })))
      @mock.expects(:post).once.returns(test_response(test_customer({ :mnemonic => "bar" })))
      c = Payjp::Customer.new("test_customer").refresh
      assert_equal "foo", c.mnemonic
      c.mnemonic = "bar"
      c.save
      assert_equal "bar", c.mnemonic
    end

    should "create should return a new customer" do
      @mock.expects(:post).once.returns(test_response(test_customer))
      c = Payjp::Customer.create
      assert_equal "c_test_customer", c.id
    end
  end
end
