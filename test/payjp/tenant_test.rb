require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class TenantTest < Test::Unit::TestCase
    should "tenants should be listable" do
      @mock.expects(:get).once.returns(test_response(test_tenant_array))
      c = Payjp::Tenant.all.data
      assert c.is_a? Array
      assert c[0].is_a? Payjp::Tenant
    end

    should "tenants should be deletable" do
      @mock.expects(:delete).once.returns(test_response(test_tenant))
      c = Payjp::Tenant.new("test_tenant")
      c.delete
    end

    should "tenants should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_tenant({ :name => "foo" })))
      @mock.expects(:post).once.returns(test_response(test_tenant({ :name => "bar" })))
      c = Payjp::Tenant.new("test_tenant").refresh
      assert_equal "foo", c.name
      c.name = "bar"
      c.save
      assert_equal "bar", c.name
    end

    should "create should return a new tenant" do
      @mock.expects(:post).once.returns(test_response(test_tenant(:id => 'test_tenant1')))
      c = Payjp::Tenant.create(:id => 'test_tenant1')
      assert_equal "test_tenant1", c.id
    end

    should "create_application_urls should be callable" do
      @mock.expects(:get).never
      @mock.expects(:post).once.returns(test_response({ :object => "application_url", :url => 'https://pay.jp/_/applications/start/c24368137e384aa9xxxxxxxxxxxxxxxx', :expires => 1476676539 }))
      c = Payjp::Tenant.new('test_tenant')
      response = c.create_application_urls()
      assert_equal response[:url], 'https://pay.jp/_/applications/start/c24368137e384aa9xxxxxxxxxxxxxxxx'
    end
  end
end
