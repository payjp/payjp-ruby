require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class StatementTest < Test::Unit::TestCase
    should "statement should be listable" do
      @mock.expects(:get).once.returns(test_response(test_statement_array))
      statements = Payjp::Statement.all.data
      assert statements.is_a? Array
      assert statements[0].is_a? Payjp::Statement
    end

    should "be retrievable" do
      @mock.expects(:get).once.returns(test_response(test_statement))
      statement = Payjp::Statement.retrieve('st_test')
      assert statement.is_a? Payjp::Statement
      assert_equal 'st_test', statement.id
      assert_equal 'statement', statement.object
      assert statement.to_hash.has_key?(:items)
      assert statement.items[0].to_hash.has_key?(:amount)
      assert statement.items[0].to_hash.has_key?(:name)
      assert statement.items[0].to_hash.has_key?(:subject)
      assert statement.items[0].to_hash.has_key?(:tax_rate)
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
