require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class TransferTest < Test::Unit::TestCase
    should "transfers should be listable" do
      @mock.expects(:get).once.returns(test_response(test_transfer_array))
      c = Payjp::Transfer.all.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Transfer
    end

    should "retrieve should retrieve transfer" do
      @mock.expects(:get).once.returns(test_response(test_transfer))
      transfer = Payjp::Transfer.retrieve('tr_test_transfer')
      assert_equal 'tr_test_transfer', transfer.id
    end

    should "transfers should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_transfer))
        transfer = Payjp::Transfer.retrieve('tr_test_transfer')
        transfer.delete
      end
    end

    should "transfer.charges should return charge list" do
      @mock.expects(:get).once.returns(test_response(test_transfer))
      transfer = Payjp::Transfer.retrieve('tr_test_transfer')
      c = transfer.charges.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Charge
    end
  end
end
