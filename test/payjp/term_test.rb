require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class TermTest < Test::Unit::TestCase
    should "terms should be listable" do
      @mock.expects(:get).once.returns(test_response(test_term_array))
      c = Payjp::Term.all.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Term
    end

    should "retrieve should retrieve term" do
      @mock.expects(:get).once.returns(test_response(test_term))
      term = Payjp::Term.retrieve('tm_test_term')
      assert_equal 'tm_test_term', term.id
    end

    should "terms should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_term))
        term = Payjp::Term.retrieve('tm_test_term')
        term.delete
      end
    end
  end
end
