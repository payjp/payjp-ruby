module Payjp
  class Tenant < APIResource
    include Payjp::APIOperations::Create
    include Payjp::APIOperations::Delete
    include Payjp::APIOperations::Update
    include Payjp::APIOperations::List

    def create_application_urls(params = {}, opts = {})
      response, opts = request(:post, create_application_urls_url, params, opts)
      response
    end

    private

    def create_application_urls_url
      url + '/application_urls'
    end
  end
end
