require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class ListObjectTest < Test::Unit::TestCase
    should "be able to retrieve full lists given a listobject" do
      @mock.expects(:get).twice.returns(test_response(test_charge_array))
      c = Payjp::Charge.all
      assert c.is_a?(Payjp::ListObject)
      assert_equal('/v1/charges', c.url)
      all = c.all
      assert all.is_a?(Payjp::ListObject)
      assert_equal('/v1/charges', all.url)
      assert all.data.is_a?(Array)
    end
  end
end
