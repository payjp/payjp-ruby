require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class PlanTest < Test::Unit::TestCase
    should "create should return a new plan" do
      @mock.expects(:post).once.returns(test_response(test_plan))
      plan = Payjp::Plan.create({
        :amount => 500,
        :currency => 'jpy',
        :interval => 'month',
        :trial_days => 30
      })
      assert_equal 'pln_test_plan', plan.id
    end

    should "retrieve should retrieve plan" do
      @mock.expects(:get).once.returns(test_response(test_plan))
      plan = Payjp::Plan.retrieve('pln_test_plan')
      assert_equal 'pln_test_plan', plan.id
    end

    should "plans should be deletable" do
      @mock.expects(:delete).once.returns(test_response(test_plan({ :deleted => true })))
      plan = Payjp::Plan.new("test_plan")
      plan.delete
      assert plan.deleted
    end

    should "plans should be listable" do
      @mock.expects(:get).once.returns(test_response(test_plan_array))
      plans = Payjp::Plan.all
      assert plans.data.is_a? Array
      plans.each do |plan|
        assert plan.is_a?(Payjp::Plan)
      end
    end

    should "plans should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_plan({ :name => 'current plan' })))
      @mock.expects(:post).once.returns(test_response(test_plan({ :name => 'new plan' })))
      plan = Payjp::Plan.new("test_plan").refresh
      assert_equal 'current plan', plan.name
      plan.name = 'new plan'
      plan.save
      assert_equal 'new plan', plan.name
    end
  end
end
