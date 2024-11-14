module Payjp
  class ThreeDSecureRequest < APIResource
    include Payjp::APIOperations::List
    include Payjp::APIOperations::Create

    def self.url
      "/v1/three_d_secure_requests"
    end
  end
end
