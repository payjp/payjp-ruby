require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class TokenTest < Test::Unit::TestCase
    should "create should return a new token" do
      @mock.expects(:post).once.returns(test_response(test_token))
      token = Payjp::Token.create({
        :card => {
          :number => '4242424242424242',
          :exp_month => 2,
          :exp_year => 2020
        }
      })
      assert_equal Payjp::Token, token.class
      assert_equal 'tok_test_token', token.id
    end

    should "retrieve should retrieve token" do
      @mock.expects(:get).once.returns(test_response(test_token))
      token = Payjp::Token.retrieve('tok_test_token')

      assert_equal Payjp::Token, token.class
      assert_equal 'tok_test_token', token.id
    end

    should "token should not be deletable" do
      assert_raises NoMethodError do
        @mock.expects(:get).once.returns(test_response(test_token))
        token = Payjp::Token.retrieve('tok_test_token')
        token.delete
      end
    end
  end
end
