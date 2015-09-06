require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class EventTest < Test::Unit::TestCase
    should "events should be listable" do
      @mock.expects(:get).once.returns(test_response(test_event_array))
      c = Payjp::Event.all.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Event
    end

    should "retrieve should retrieve event" do
      @mock.expects(:get).once.returns(test_response(test_event))
      event = Payjp::Event.retrieve('tr_test_event')
      assert_equal 'evnt_test_event', event.id
    end

    should "events should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_event))
        event = Payjp::Event.retrieve('evnt_test_event')
        event.delete
      end
    end
  end
end
