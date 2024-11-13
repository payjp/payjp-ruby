require File.expand_path('../../test_helper', __FILE__)

module Payjp
  class ThreeDSecureRequestTest < Test::Unit::TestCase
    should "three_d_secure_requests should be listable" do
      @mock.expects(:get).once.returns(test_response(test_three_d_secure_request_array))
      response = Payjp::ThreeDSecureRequest.all
      assert response.data.is_a? Array
      response.each do |three_d_secure_request|
        assert three_d_secure_request.is_a?(Payjp::ThreeDSecureRequest)
      end
    end

    should "three_d_secure_requests should be creatable" do
      resource_id = 'car_xxx_test1'
      tenant_id = 'ten_xxx_test1'
      @mock.expects(:post).with do |url, api_key, params|
        url == "#{Payjp.api_base}/v1/three_d_secure_requests" && api_key.nil? && CGI.parse(params) == {
          'resource_id' => [resource_id],
          'tenant_id' => [tenant_id],
        }
      end.once.returns(test_response(test_three_d_secure_request({:resource_id => resource_id, :tenant_id => tenant_id})))

      response = Payjp::ThreeDSecureRequest.create({
        :resource_id => resource_id,
        :tenant_id => tenant_id,
      })
      assert response.resource_id == resource_id
      assert response.tenant_id == tenant_id
    end

    should "three_d_secure_requests should be retrievable" do
      tdsr_id = 'tdsr_xxx_test1'
      @mock.expects(:get).once.returns(test_response(test_three_d_secure_request({:id => tdsr_id})))
      response = Payjp::ThreeDSecureRequest.retrieve(tdsr_id)
      assert_equal Payjp::ThreeDSecureRequest, response.class
      assert_equal response.id, tdsr_id
    end
  end
end
