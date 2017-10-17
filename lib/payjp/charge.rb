module Payjp
  class Charge < APIResource
    include Payjp::APIOperations::List
    include Payjp::APIOperations::Create
    include Payjp::APIOperations::Update

    def refund(params = {}, opts = {})
      response, opts = request(:post, refund_url, params, opts)
      refresh_from(response, opts)
    end

    def capture(params = {}, opts = {})
      response, opts = request(:post, capture_url, params, opts)
      refresh_from(response, opts)
    end

    def reauth(params = {}, opts = {})
      response, opts = request(:post, reauth_url, params, opts)
      refresh_from(response, opts)
    end

    private

    def refund_url
      url + '/refund'
    end

    def capture_url
      url + '/capture'
    end

    def reauth_url
      url + '/reauth'
    end
  end
end
